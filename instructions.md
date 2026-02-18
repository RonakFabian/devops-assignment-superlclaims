To run locally:

- Clone or download the git hub repo
- Open index.html under frontend folder
- Open a terminal in the main directory and run command:
  `docker compose up`
- This docker compose have all 3 services (redis,worker and backend) as docker containers
- Type `docker ps` to get a list of all the containers running and type `docker exec -it my_container_name sh` to exec into it
- The env are entered into the compose file for local purposes only, it is not pushed to git (added to .gitignore). GitHub actions sends the
  env and secrets data to the containers.
