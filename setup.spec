# -*- mode: python ; coding: utf-8 -*-

import os

dir = os.path.abspath("./")

with open(os.path.join(dir, "atus", "version.txt"), encoding="utf-8") as f:
   __VERSION__ = f.read()

block_cipher = None


a = Analysis([os.path.join(dir, "atus", "main.py")],
             pathex=[
               os.path.join(dir, "venv"),
               os.path.join(dir, "venv", "Lib", "site-packages"),
               'atus',
               'atus/src'
             ],
             binaries=[],
             datas=[
                (os.path.join(dir, "atus", "images"), 'images'),
                (os.path.join(dir, "atus", "qml"), 'qml'),
                (os.path.join(dir, "atus", "icon.ico"), '.'),
                (os.path.join(dir, "atus", "version.txt"), '.')
             ],
             hiddenimports=[],
             hookspath=[],
             hooksconfig={},
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)

pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)

exe = EXE(pyz,
          a.scripts, 
          [],
          # exclude_binaries=True,
          exclude_binaries=False,
          name='main',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=False,
          disable_windowed_traceback=False,
          target_arch=None,
          codesign_identity=None,
          entitlements_file=None,
          icon=os.path.join(dir, "atus", "icon.ico"))

coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas, 
               strip=False,
               upx=True,
               upx_exclude=[],
               name=f'atus_{__VERSION__}')
