### Fill Complete Journey

Locally:

- Forked the project and tried running locally
- Learnt that celery has issues with windows and python versions above 3.9 and above, reverted the version and used wsl to run redis locally
- Opened html front and saw the services working as intended
- Used multistage docker to containerize the application, didnt feel a need to containzer frontend as it was simply an html file
- Used official redis docker file
- Implemented docker-compose.yml to run all 3 containers
- Noticed some of the env were hardcoded in worker.py, so used env constants to overide based on current environmen.
- Added env values in the worker service section
- Typed docker-compose up and observed all 3 containers working well and emitting 200 status
- Implemented 4 github action workflows to split responsibilities
- 1. frontend-tf.yml - to spin up aws s3 and cloudfront resources (workflow_dispatch)
  2. frontend-deploy.yml- to push the html file into the mentioned s3 and making it publicly accessable and invalidation cdn cache
  3. backend-tf.yml - to spin up vpc, ecs, tasks, iam permissions,and cloudwatch metrics
  4. backend-deploy.yml- to checkout, build docker images and test using trivy vulnerability scanner, to upload to aws ecr and to push to ecs
- Learnt that ElastiCache is preffered for deploying Redis into aws, used only 2 tasks, worker and backend
- Added cloud watch metrics and cpu alerts
- Uploaded basic diagram into github
- Thank you!
