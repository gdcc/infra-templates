## Release the infra templates 

Infra templates is a project that came to be from a need to template infrastructure in a flexible manner. With a FastAPI stack running a bit of Jinja, we end up exactly here.

The project builds to a Docker container; spinning this container allows you to make API calls, which results in valid files with glorious Terraform.

Furthermore, infra templates can be used to host cloudinit scripting with similar mechanics, and bash scripts which can be pulled from the container. Who doesn't love recursivity?

### Starting up

1. Clone the repo
2. `docker compose build`
3. `docker compose up`
4. `Go to http://localhost:6067`

Alternatively pull an image from Dockerhub from thomasve.

### Local development

1. Clone the repo.
2. All code lives in main.py, go crazy there. Templats can be added in the templates folder.

### Upgrading

1. Clone repo
2. Ideally, install poetry.
3. Make changes to pyproject.toml file
4. `docker compose build`
