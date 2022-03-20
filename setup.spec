# -*- mode: python ; coding: utf-8 -*-

with open("atus/version.txt", encoding="utf-8") as f:
   __VERSION__ = f.read()

block_cipher = None


a = Analysis(['atus\\main.py'],
             pathex=[
               r'C:\Users\leoei\Documents\Analysis-Tool-for-Undergrad-Students\venv',
               r'C:\Users\leoei\Documents\Analysis-Tool-for-Undergrad-Students\venv\Lib\site-packages',
               'atus'],
             binaries=[],
             datas=[
                ('atus\\images', 'images'),
                ('atus\\qml', 'qml'),
                ('atus\\icon.ico', '.'),
                ('atus\\version.txt', '.')
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
          exclude_binaries=True,
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
          icon='atus\\icon.ico')

coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas, 
               strip=False,
               upx=True,
               upx_exclude=[],
               name=f'atus_{__VERSION__}')
