# TIPS

### To see the development log from Rails

   ```
    docker-compose exec app tail -f log/development.log
   ```

### To ssh into your container

If your container is running

```
docker-compose exec app /bin/sh
```

Replace `app` with `web` or `db` if you want to ssh into the nginx or postgres container.

If your container is not running
```
docker run -it <IMAGE ID> /bin/sh
```
