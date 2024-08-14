# alpine 3.19 버전 리눅스, 파이썬은 3.11로 설치된 이미지 부르기
# alpine - 경량화된 리눅스 버전
# 빌드가 계속 반복되어야 하는데, 이미지가 무거우면 빌드 속도 느려짐.
FROM python:3.11-alpine3.19

LABEL maintainer='loafingcat'

ENV PYTHONUNBUFFERD=1

# 최대한 컨테이너를 경량상태로 유지하기 위해
# tmp 폴더는 빌드가 완료되면 삭제합니다.
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user