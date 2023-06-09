# infra-templates
API to create templates for cloud infrastructure intended for the automated Dataverse deployment on various cloud platforms.

Collaborative service created and maintained by [DANS-KNAW](https://dans.knaw.nl/en/), [GDCC](http://dataversecommunity.global), [Forschungszentrum Jülich](https://www.fz-juelich.de) and [Harvard IQSS](https://www.iq.harvard.edu). Initially developed by [thomasve-DANS](https://github.com/thomasve-DANS).

### Starting up

1. Clone the repo and go to the folder.
2. `cp .env_sample .env` 
3. `docker compose build`
4. `docker compose up`
5. `Go to http://localhost:6067`

Alternatively pull an image from Dockerhub from thomasve.

### Local development

1. Clone the repo.
2. All code lives in main.py, go crazy there. Templates can be added in the "templates" folder.

### Upgrading

1. Clone repo
2. Ideally, install poetry.
3. Make changes to pyproject.toml file
4. `docker compose build`

### Testing

1. Repo is tested by pytest; this can be called to run in Docker.
