FROM listmonk/listmonk:latest
CMD ["sh", "-c", "./listmonk --install --idempotent --yes && ./listmonk --upgrade --yes  && ./listmonk"]
