# -*- coding: utf-8 -*-
"""
MIT License

Copyright (c) 2021 Leonardo Eiji Tamayose, Guilherme Ferrari Fortino

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

from __future__ import print_function
import os.path

# from matplotlib_backend_qtquick.qt_compat import QtCore
from PyQt5.QtCore import QObject, pyqtProperty, QUrl, pyqtSignal, pyqtSlot, QJsonValue

# from googleapiclient.discovery import build
# from googleapiclient.http import MediaFileUpload
# from google_auth_oauthlib.flow import InstalledAppFlow
# from google.auth.transport.requests import Request
# from google.oauth2.credentials import Credentials


class GDrive(QObject):
    """Class that interact with google drive API"""

    # Signals
    informationSignal = pyqtSignal(QJsonValue, arguments="ownersInfo")

    def __init__(self, messageHandler):
        super().__init__()

        # Paths
        self.credsPath = os.path.join(
            os.path.abspath(__file__), "../../credentials.json"
        )
        self.tokenPath = os.path.join(os.path.expanduser("~/Documents"), "token.json")

        # print(self.credsPath)
        # print(self.tokenPath)
        # print(os.path.exists(self.credsPath))
        # print(os.path.exists(self.tokenPath))

        # Properties
        self.messageHandler = messageHandler
        self.creds = None
        self.service = None

        # If modifying these scopes, delete the file token.json.
        self.SCOPES = [
            "https://www.googleapis.com/auth/drive.metadata.readonly",
            "https://www.googleapis.com/auth/drive.appdata",
            "https://www.googleapis.com/auth/userinfo.profile",
        ]

    # @pyqtSlot()
    # def tryLogin(self):
    #     '''
    #         Called when the program is initialized, try to connect with Google if there's already a token
    #     '''
    #     # If there's already a token, get creds
    #     if os.path.exists(self.tokenPath):
    #         self.creds = Credentials.from_authorized_user_file(self.tokenPath, self.SCOPES)
    #         about = self.getDrive()
    #         self.informationSignal.emit(QJsonValue.fromVariant(about))

    # @pyqtSlot()
    # def login(self):
    #     '''
    #         Connect to Google Drive API and get user's information
    #     '''
    #     # If there are no (valid) credentials available, let the user log in.
    #     if not self.creds or not self.creds.valid:
    #         if self.creds and self.creds.expired and self.creds.refresh_token:
    #             try:
    #                 self.creds.refresh(Request())
    #             except:
    #                 return 0
    #         else:
    #             flow = InstalledAppFlow.from_client_secrets_file('credentials.json', self.SCOPES)
    #             try:
    #                 self.creds = flow.run_local_server(port=0)
    #             except:
    #                 return 0

    #         # Save the credentials for the next run
    #         with open(self.tokenPath, 'w') as token:
    #             token.write(self.creds.to_json())

    #         # Mounting drive
    #         about = self.getDrive()
    #         self.informationSignal.emit(QJsonValue.fromVariant(about))

    # @pyqtSlot()
    # def logout(self):
    #     '''
    #         Closes http2lib connection
    #     '''
    #     self.service.close()

    #     # Removing token
    #     os.remove(self.tokenPath)
    #     self.service = None
    #     self.creds = None

    # @pyqtSlot()
    # def listFiles(self):
    #     results = self.service.files().list(spaces='appDataFolder', fields="nextPageToken, files(id, name)", q="mimeType='application/json'").execute()
    #     print(results.get('files', []))
    #     # return results.get('files', [])

    # @pyqtSlot()
    # def uploadFile(self):
    #     file_metadata = {
    #         'name': 'config.json',
    #         'parents': ['appDataFolder']
    #     }
    #     media = MediaFileUpload(self.tokenPath,
    #                             mimetype='application/json',
    #                             resumable=True)
    #     file = self.service.files().create(body=file_metadata,
    #                                         media_body=media,
    #                                         fields='id').execute()
    #     print('File ID: %s' % file.get('id'))

    # def getDrive(self):
    #     '''
    #         Build Google Drive API
    #         Returns: information about the drive's owner
    #     '''
    #     # Building drive
    #     self.service = build('drive', 'v3', credentials=self.creds)

    #     # Getting information about drive's owner
    #     about = self.service.about().get(fields='user').execute()

    #     return about
