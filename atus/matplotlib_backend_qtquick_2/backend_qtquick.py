import os
import traceback

import matplotlib

from matplotlib import cbook
from matplotlib.backend_bases import (
    FigureCanvasBase, NavigationToolbar2,
    MouseButton)
from matplotlib.figure import Figure
from matplotlib.backends.backend_qt import (
    TimerQT, SPECIAL_KEYS, _MODIFIER_KEYS as MODIFIER_KEYS, cursord)
from .qt_compat import (
    QtCore, QtGui, QtQuick, QtWidgets,
    QT_API, QT_API_PYSIDE2, QT_API_PYSIDE6)


class FigureCanvasQtQuick(QtQuick.QQuickPaintedItem, FigureCanvasBase):
    """ This class creates a QtQuick Item encapsulating a Matplotlib
        Figure and all the functions to interact with the 'standard'
        Matplotlib navigation toolbar.
    """

    dpi_ratio_changed = QtCore.Signal()

    # map Qt button codes to MouseEvent's ones:
    buttond = {QtCore.Qt.LeftButton: MouseButton.LEFT,
               QtCore.Qt.MiddleButton: MouseButton.MIDDLE,
               QtCore.Qt.RightButton: MouseButton.RIGHT,
               QtCore.Qt.XButton1: MouseButton.BACK,
               QtCore.Qt.XButton2: MouseButton.FORWARD,
               }

    def __init__(self, figure=None, parent=None):
        if figure is None:
            figure = Figure((6.0, 4.0))

        # It seems like Qt doesn't implement cooperative inheritance
        QtQuick.QQuickPaintedItem.__init__(self, parent=parent)
        FigureCanvasBase.__init__(self, figure=figure)

        # The dpi ratio (property without leading _)
        self._dpi_ratio = 1

        # Activate hover events and mouse press events
        self.setAcceptHoverEvents(True)
        self.setAcceptedMouseButtons(QtCore.Qt.AllButtons)
        self.setAntialiasing(True)
        # We don't want to scale up the figure DPI more than once.
        # Note, we don't handle a signal for changing DPI yet.
        figure._original_dpi = figure.dpi
        self._update_figure_dpi()
        # In cases with mixed resolution displays, we need to be careful if the
        # dpi_ratio changes - in this case we need to resize the canvas
        # accordingly. We could watch for screenChanged events from Qt, but
        # the issue is that we can't guarantee this will be emitted *before*
        # the first paintEvent for the canvas, so instead we keep track of the
        # dpi_ratio value here and in paintEvent we resize the canvas if
        # needed.

        self._draw_pending = False
        self._is_drawing = False
        self._draw_rect_callback = lambda painter: None

        self.resize(*self.get_width_height())

    def _update_figure_dpi(self):
        dpi = self.dpi_ratio * self.figure._original_dpi
        self.figure._set_dpi(dpi, forward=False)

    # property exposed to Qt
    def get_dpi_ratio(self):
        return self._dpi_ratio

    def boundingRect(self):
        return QtCore.QRectF(0, 0, self.width(), self.height())

    def set_dpi_ratio(self, new_ratio):
        # As described in __init__ above, we need to be careful in cases with
        # mixed resolution displays if dpi_ratio is changing between painting
        # events.
        # Return whether we triggered a resizeEvent (and thus a paintEvent)
        # from within this function.
        if new_ratio != self._dpi_ratio:
            self._dpi_ratio = new_ratio
            # We need to update the figure DPI.
            self._update_figure_dpi()
            # The easiest way to resize the canvas is to emit a resizeEvent
            # since we implement all the logic for resizing the canvas for
            # that event.
            self.geometryChanged(self.boundingRect(), self.boundingRect())
            # resizeEvent triggers a paintEvent itself, so we exit this one
            # (after making sure that the event is immediately handled).

    dpi_ratio = QtCore.Property(float,
                                get_dpi_ratio,
                                set_dpi_ratio,
                                notify=dpi_ratio_changed)

    def get_width_height(self):
        w, h = FigureCanvasBase.get_width_height(self)
        return int(w / self.dpi_ratio), int(h / self.dpi_ratio)

    def drawRectangle(self, rect):
        # Draw the zoom rectangle to the QPainter.  _draw_rect_callback needs
        # to be called at the end of paintEvent.
        if rect is not None:
            def _draw_rect_callback(painter):
                pen = QtGui.QPen(QtCore.Qt.black, 1 / self.dpi_ratio,
                                 QtCore.Qt.DotLine)
                painter.setPen(pen)
                painter.drawRect(QtCore.QRectF(*(pt / self.dpi_ratio for pt in rect)))
        else:
            def _draw_rect_callback(painter):
                return
        self._draw_rect_callback = _draw_rect_callback
        self.update()

    def draw(self):
        """Render the figure, and queue a request for a Qt draw.
        """
        # The renderer draw is done here; delaying causes problems with code
        # that uses the result of the draw() to update plot elements.
        if self._is_drawing:
            return
        with cbook._setattr_cm(self, _is_drawing=True):
            super().draw()
        self.update()

    def draw_idle(self):
        """
        Queue redraw of the Agg buffer and request Qt paintEvent.
        """
        # The Agg draw needs to be handled by the same thread matplotlib
        # modifies the scene graph from. Post Agg draw request to the
        # current event loop in order to ensure thread affinity and to
        # accumulate multiple draw requests from event handling.
        # TODO: queued signal connection might be safer than singleShot
        if not (getattr(self, '_draw_pending', False) or
                getattr(self, '_is_drawing', False)):
            self._draw_pending = True
            QtCore.QTimer.singleShot(0, self._draw_idle)

    def _draw_idle(self):
        with self._idle_draw_cntx():
            if not self._draw_pending:
                return
            self._draw_pending = False
            if self.height() < 0 or self.width() < 0:
                return
            try:
                self.draw()
            except Exception:
                # Uncaught exceptions are fatal for PyQt5, so catch them.
                traceback.print_exc()

    def geometryChangeHelper(self, new_geometry, old_geometry):
        w = new_geometry.width() * self.dpi_ratio
        h = new_geometry.height() * self.dpi_ratio

        if (w <= 0.0) or (h <= 0.0):
            return

        dpival = self.figure.dpi
        winch = w / dpival
        hinch = h / dpival
        self.figure.set_size_inches(winch, hinch, forward=False)
        FigureCanvasBase.resize_event(self)
        self.draw_idle()

    # Overload for Qt 6
    def geometryChange(self, new_geometry, old_geometry):
        self.geometryChangeHelper(new_geometry, old_geometry)
        QtQuick.QQuickPaintedItem.geometryChange(self,
                                                 new_geometry,
                                                 old_geometry)

    # Overload for Qt 5
    def geometryChanged(self, new_geometry, old_geometry):
        self.geometryChangeHelper(new_geometry, old_geometry)
        QtQuick.QQuickPaintedItem.geometryChanged(self,
                                                  new_geometry,
                                                  old_geometry)

    def sizeHint(self):
        w, h = self.get_width_height()
        return QtCore.QSize(w, h)

    def minumumSizeHint(self):
        return QtCore.QSize(10, 10)

    def hoverEnterEvent(self, event):
        try:
            x, y = self.mouseEventCoords(event.pos())
        except AttributeError:
            # the event from PyQt4 does not include the position
            x = y = None
        FigureCanvasBase.enter_notify_event(self, guiEvent=event, xy=(x, y))

    def hoverLeaveEvent(self, event):
        QtWidgets.QApplication.restoreOverrideCursor()
        FigureCanvasBase.leave_notify_event(self, guiEvent=event)

    def mouseEventCoords(self, pos):
        """Calculate mouse coordinates in physical pixels

        Qt5 use logical pixels, but the figure is scaled to physical
        pixels for rendering.   Transform to physical pixels so that
        all of the down-stream transforms work as expected.

        Also, the origin is different and needs to be corrected.

        """
        dpi_ratio = self.dpi_ratio
        x = pos.x()
        # flip y so y=0 is bottom of canvas
        y = self.figure.bbox.height / dpi_ratio - pos.y()
        return x * dpi_ratio, y * dpi_ratio

    def hoverMoveEvent(self, event):
        x, y = self.mouseEventCoords(event.pos())
        FigureCanvasBase.motion_notify_event(self, x, y, guiEvent=event)

    # hoverMoveEvent kicks in when no mouse buttons are pressed
    # otherwise mouseMoveEvent are emitted
    def mouseMoveEvent(self, event):
        x, y = self.mouseEventCoords(event.pos())
        FigureCanvasBase.motion_notify_event(self, x, y, guiEvent=event)

    def mousePressEvent(self, event):
        x, y = self.mouseEventCoords(event.pos())
        button = self.buttond.get(event.button())
        if button is not None:
            FigureCanvasBase.button_press_event(self, x, y, button,
                                                guiEvent=event)

    def mouseReleaseEvent(self, event):
        x, y = self.mouseEventCoords(event.pos())
        button = self.buttond.get(event.button())
        if button is not None:
            FigureCanvasBase.button_release_event(self, x, y, button,
                                                  guiEvent=event)

    def mouseDoubleClickEvent(self, event):
        x, y = self.mouseEventCoords(event.pos())
        button = self.buttond.get(event.button())
        if button is not None:
            FigureCanvasBase.button_press_event(self, x, y,
                                                button, dblclick=True,
                                                guiEvent=event)

    def wheelEvent(self, event):
        x, y = self.mouseEventCoords(event.position())
        # from QWheelEvent::delta doc
        if event.pixelDelta().x() == 0 and event.pixelDelta().y() == 0:
            steps = event.angleDelta().y() / 120
        else:
            steps = event.pixelDelta().y()
        if steps:
            FigureCanvasBase.scroll_event(self, x, y, steps, guiEvent=event)

    def keyPressEvent(self, event):
        key = self._get_key(event)
        if key is not None:
            FigureCanvasBase.key_press_event(self, key, guiEvent=event)

    def keyReleaseEvent(self, event):
        key = self._get_key(event)
        if key is not None:
            FigureCanvasBase.key_release_event(self, key, guiEvent=event)

    def _get_key(self, event):
        # if event.isAutoRepeat():
        #     return None

        event_key = event.key()
        event_mods = int(event.modifiers())  # actually a bitmask

        # get names of the pressed modifier keys
        # bit twiddling to pick out modifier keys from event_mods bitmask,
        # if event_key is a MODIFIER, it should not be duplicated in mods
        mods = [name for name, mod_key, qt_key in MODIFIER_KEYS
                if event_key != qt_key and (event_mods & mod_key) == mod_key]
        try:
            # for certain keys (enter, left, backspace, etc) use a word for the
            # key, rather than unicode
            key = SPECIAL_KEYS[event_key]
        except KeyError:
            # unicode defines code points up to 0x0010ffff
            # QT will use Key_Codes larger than that for keyboard keys that are
            # are not unicode characters (like multimedia keys)
            # skip these
            # if you really want them, you should add them to SPECIAL_KEYS
            MAX_UNICODE = 0x10ffff
            if event_key > MAX_UNICODE:
                return None

            key = chr(event_key)
            # qt delivers capitalized letters.  fix capitalization
            # note that capslock is ignored
            if 'shift' in mods:
                mods.remove('shift')
            else:
                key = key.lower()

        mods.reverse()
        return '+'.join(mods + [key])

    def new_timer(self, *args, **kwargs):
        """
        Creates a new backend-specific subclass of
        :class:`backend_bases.Timer`.  This is useful for getting
        periodic events through the backend's native event
        loop. Implemented only for backends with GUIs.

        optional arguments:

        *interval*
            Timer interval in milliseconds

        *callbacks*
            Sequence of (func, args, kwargs) where func(*args, **kwargs)
            will be executed by the timer every *interval*.
        """
        return TimerQT(*args, **kwargs)

    def flush_events(self):
        global qApp
        qApp.processEvents()


class MatplotlibIconProvider(QtQuick.QQuickImageProvider):
    """ This class provide the matplotlib icons for the navigation toolbar.
    """

    def __init__(self, img_type=QtQuick.QQuickImageProvider.Image):
        self.basedir = os.path.join(matplotlib.rcParams['datapath'], 'images')
        QtQuick.QQuickImageProvider.__init__(self, img_type)

    def requestImage(self, ids, size, reqSize):
        img = QtGui.QImage(os.path.join(self.basedir, ids + '.png'))
        size.setWidth(img.width())
        size.setHeight(img.height())
        return img


class NavigationToolbar2QtQuick(QtCore.QObject, NavigationToolbar2):
    """ NavigationToolbar2 customized for QtQuick
    """

    messageChanged = QtCore.Signal(str)

    leftChanged = QtCore.Signal()
    rightChanged = QtCore.Signal()
    topChanged = QtCore.Signal()
    bottomChanged = QtCore.Signal()
    wspaceChanged = QtCore.Signal()
    hspaceChanged = QtCore.Signal()

    def __init__(self, canvas, parent=None):

        # I think this is needed due to a bug in PySide2
        if QT_API in [QT_API_PYSIDE2, QT_API_PYSIDE6]:
            QtCore.QObject.__init__(self, parent)
            NavigationToolbar2.__init__(self, canvas)
        else:
            super().__init__(canvas=canvas, parent=parent)

        self._message = ""

        #
        # Store margin
        #
        self._defaults = {}
        for attr in ('left', 'bottom', 'right', 'top', 'wspace', 'hspace', ):
            val = getattr(self.canvas.figure.subplotpars, attr)
            self._defaults[attr] = val
            setattr(self, attr, val)

    def _init_toolbar(self):
        """ don't actually build the widgets here, build them in QML
        """
        pass

    # Define a few properties.
    def getMessage(self):
        return self._message

    def setMessage(self, msg):
        if msg != self._message:
            self._message = msg
            self.messageChanged.emit(msg)

    message = QtCore.Property(str, getMessage, setMessage,
                              notify=messageChanged)

    def getLeft(self):
        return self.canvas.figure.subplotpars.left

    def setLeft(self, value):
        if value != self.canvas.figure.subplotpars.left:
            self.canvas.figure.subplots_adjust(left=value)
            self.leftChanged.emit()

            self.canvas.draw_idle()

    left = QtCore.Property(float, getLeft, setLeft, notify=leftChanged)

    def getRight(self):
        return self.canvas.figure.subplotpars.right

    def setRight(self, value):
        if value != self.canvas.figure.subplotpars.right:
            self.canvas.figure.subplots_adjust(right=value)
            self.rightChanged.emit()

            self.canvas.draw_idle()

    right = QtCore.Property(float, getRight, setRight, notify=rightChanged)

    def getTop(self):
        return self.canvas.figure.subplotpars.top

    def setTop(self, value):
        if value != self.canvas.figure.subplotpars.top:
            self.canvas.figure.subplots_adjust(top=value)
            self.topChanged.emit()

            self.canvas.draw_idle()

    top = QtCore.Property(float, getTop, setTop, notify=topChanged)

    def getBottom(self):
        return self.canvas.figure.subplotpars.bottom

    def setBottom(self, value):
        if value != self.canvas.figure.subplotpars.bottom:
            self.canvas.figure.subplots_adjust(bottom=value)
            self.bottomChanged.emit()

            self.canvas.draw_idle()

    bottom = QtCore.Property(float, getBottom, setBottom, notify=bottomChanged)

    def getHspace(self):
        return self.canvas.figure.subplotpars.hspace

    def setHspace(self, value):
        if value != self.canvas.figure.subplotpars.hspace:
            self.canvas.figure.subplots_adjust(hspace=value)
            self.hspaceChanged.emit()

            self.canvas.draw_idle()

    hspace = QtCore.Property(float, getHspace, setHspace, notify=hspaceChanged)

    def getWspace(self):
        return self.canvas.figure.subplotpars.wspace

    def setWspace(self, value):
        if value != self.canvas.figure.subplotpars.wspace:
            self.canvas.figure.subplots_adjust(wspace=value)
            self.wspaceChanged.emit()

            self.canvas.draw_idle()

    wspace = QtCore.Property(float, getWspace, setWspace, notify=wspaceChanged)

    def set_history_buttons(self):
        """Enable or disable back/forward button"""
        pass

    def set_cursor(self, cursor):
        """
        Set the current cursor to one of the :class:`Cursors`
        enums values
        """
        self.canvas.setCursor(cursord[cursor])

    def draw_with_locators_update(self):
        """Redraw the canvases, update the locators"""
        for a in self.canvas.figure.get_axes():
            xaxis = getattr(a, 'xaxis', None)
            yaxis = getattr(a, 'yaxis', None)
            locators = []
            if xaxis is not None:
                locators.append(xaxis.get_major_locator())
                locators.append(xaxis.get_minor_locator())
            if yaxis is not None:
                locators.append(yaxis.get_major_locator())
                locators.append(yaxis.get_minor_locator())

            for loc in locators:
                loc.refresh()
        self.canvas.draw_idle()

    def draw_rubberband(self, event, x0, y0, x1, y1):
        """Draw a rectangle rubberband to indicate zoom limits"""
        height = self.canvas.figure.bbox.height
        y1 = height - y1
        y0 = height - y0

        w = abs(x1 - x0)
        h = abs(y1 - y0)

        rect = [int(val)for val in (min(x0, x1), min(y0, y1), w, h)]
        self.canvas.drawRectangle(rect)

    def remove_rubberband(self):
        """Remove the rubberband"""
        self.canvas.drawRectangle(None)

    def tight_layout(self):
        self.canvas.figure.tight_layout()
        # self._setSliderPositions()
        self.canvas.draw_idle()

    def reset_margin(self):
        self.canvas.figure.subplots_adjust(**self._defaults)
        # self._setSliderPositions()
        self.canvas.draw_idle()

    def print_figure(self, fname, *args, **kwargs):
        if fname:
            fname = QtCore.QUrl(fname).toLocalFile()
            # save dir for next time
            matplotlib.rcParams['savefig.directory'] = os.path.dirname(fname)
        NavigationToolbar2.print_figure(self, fname, *args, **kwargs)
        self.canvas.draw_idle()

    def save_figure(self, *args):
        raise NotImplementedError("save_figure is not yet implemented")
