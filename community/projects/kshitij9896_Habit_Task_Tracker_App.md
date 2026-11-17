# FlowTrack Habit_Task_Tracker_App
#BuildOnElasticBeanstalk

![Screenshot of the running app](images/kshitij9896/Habit_Task_Tracker_App1.png) ||
![Screenshot of the running app](images/kshitij9896/Habit_Task_Tracker_App2.png) ||
![Screenshot of the running app](images/kshitij9896/Habit_Task_Tracker_App3.png) 


| | |
|---|---|
| Built by | [kshitij9896] https://github.com/kshitij9896 |
| Repo | https://github.com/kshitij9896/Habit_Task_Tracker_App |
| Platform | Docker  |
| Mode | Standard |
| Deployed with | Console |

## What it does

FlowTrack is a modern, lightweight full-stack web application designed to help you track daily habits, manage tasks, and maintain consistency. Built with **Node.js**, **Express**, **Tailwind CSS**, and **vanilla JavaScript**, it features a sleek dark-mode user interface, a live dynamic progress bar, interactive category filters, a robust REST API, and production-ready Docker containerization.

## How I deployed it

Tech Stack & Tools
Frontend: Vanilla JavaScript, Tailwind CSS

Backend: Node.js, Express

Containerization: Docker

Registry: Docker Hub (dockerusername/habit-task-tracker)

Cloud Infrastructure: Amazon Elastic Beanstalk

## Deployment Architecture & Workflow
To ensure consistency, isolation, and a smooth production rollout, I decided to containerize the Habit & Task Tracker application using Docker, host the image on Docker Hub, and deploy it onto Amazon Elastic Beanstalk using a standard zip-file upload approach.

Step-by-Step Deployment Journey

1. Containerizing the Application
Created a robust Dockerfile to package the Node.js/Express application along with its dependencies.

### 1. Build the Docker Image Locally
Navigate to your project's root directory (where your `Dockerfile` is located) and run the following command to build and tag your image:

```bash
docker build -t dockerusername/habit-task-tracker:latest .

```
Successfully pushed the compiled production image to my public Docker Hub repository.

### 2. Setting up AWS Elastic Beanstalk

Initialized an Amazon Elastic Beanstalk environment designed for Docker containers.

Configured the deployment package (Dockerrun.aws.json) to pull the pre-built image straight from Docker Hub, eliminating the need for AWS to compile code directly on the EC2 instance.

Bundled the configuration file into a .zip archive and deployed it via the Elastic Beanstalk console using the Upload and Deploy file menu option.

## Troubleshooting & Overcoming Challenges

Like any real-world deployment, I ran into a couple of speedbumps along the way, which helped fine-tune the setup:

## Challenge 1: Docker Hub Repository Visibility Error

The Issue: The initial deployment failed with a pull access denied error from the Docker daemon.

The Fix: Realized the Docker Hub repository was set to Private by default. Switching the repository visibility to Public allowed Elastic Beanstalk to pull the image seamlessly without requiring complex AWS-to-Docker authentication credentials.

## Challenge 2: Port Routing & Health Check Mismatch

The Issue: The application container was listening on port 3000, but AWS Elastic Beanstalk’s load balancer expects incoming traffic to hit port 80 on the EC2 instance. This caused initial health check failures and deployment warnings.

The Fix: Adjusted the port mapping configuration to route host port 80 to container port 3000 ("80:3000"), satisfying the EB health check requirements.


## Checklist

- [x] The screenshot shows the app running
- [x] No access keys, passwords, tokens or AWS account ID in the screenshot or repo
- [x] The repo is public and has a README
- [x] I terminated the environment and deleted the application

#BuildOnElasticBeanstalk #Opensource 
