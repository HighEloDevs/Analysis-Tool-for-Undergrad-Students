FROM python:3.9

WORKDIR /usr/src/app

COPY ./requeriments.txt ./
COPY ./atus ./atus
COPY ./upx ./upx
COPY ./setup.spec .

RUN pip install -r requeriments.txt

CMD [ "pyinstaller", "--upx-dir", "./upx", "--clean", "--noconfirm", "./setup.spec", "-F" ]