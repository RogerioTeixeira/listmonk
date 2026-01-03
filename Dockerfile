FROM listmonk/listmonk:v6.0.0
CMD ["sh", "-c", "./listmonk --install --idempotent --yes && ./listmonk --upgrade --yes  && ./listmonk"]
