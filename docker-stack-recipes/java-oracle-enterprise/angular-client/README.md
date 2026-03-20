# angular-client

Put your **Angular** app here (or generate it inside `dev`). The recipe mounts this entire folder at **`/workspace/angular-client`** in the **`dev`** container.

## Create a new app (inside `dev`)

```bash
docker compose exec dev bash
cd /workspace/angular-client
ng new my-ui --defaults --skip-git
cd my-ui
ng serve --host 0.0.0.0 --port 4200
```

Host **`http://localhost:4200`** maps to container **4200** (see recipe `docker-compose.yml`).

## API base URL

From your **host** browser, call the API at **`http://localhost:8080`** (Compose publishes **`dev`**’s port **8080**).
