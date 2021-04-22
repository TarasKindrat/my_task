#!groovy

properties([disableConcurrentBuilds()])

pipeline {
    agent { 
        label 'master'
        }
    triggers { pollSCM('* * * * *') }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage("Get Deckerfile and code from gitLab ") {
            steps {
                 git 'https://gitlab.com/kindrat5/docker_files.git'
                 git 'https://gitlab.com/kindrat5/web_page.git'
                 
           }
        }
        stage("Build") {
            steps {
                 sh 'docker build --no-cache -f docker_files/Dockerfile web_page/www/ -t www_image
            }
        }
        stage("Run image") {
            steps {
                 sh 'docker run --expose 80 -d www_image
                 // -p 80:80
            }
        }
               
    }