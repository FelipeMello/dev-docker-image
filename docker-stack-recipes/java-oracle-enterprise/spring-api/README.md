# spring-api (sample)

Minimal **Spring Boot 3** + **Java 21** API with **Oracle JDBC** (`ojdbc11`). The parent recipe’s **`dev`** container sets **`ORACLE_PASSWORD`** and optional **`SPRING_DATASOURCE_*`** overrides via Compose.

## Run inside `dev`

With the stack up (`docker compose up` from the recipe root):

```bash
docker compose exec dev bash
cd /workspace/spring-api
mvn -q spring-boot:run
```

Then: **`http://localhost:8080/api/health`** (host port **8080** is published from Compose).

## Notes

- **`system`** + **`FREEPDB1`** are for **local dev only**. Use a dedicated schema user in real projects.
- If JDBC fails with a service-name error, confirm your image version’s service name (`FREE` vs `FREEPDB1`) in the [gvenzl/oracle-free](https://hub.docker.com/r/gvenzl/oracle-free) documentation.
