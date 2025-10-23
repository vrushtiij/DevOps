       pipeline {
    agent any

    stages {
        stage('Pull Repo') {
            steps {
                // Pull your T053 branch from GitHub
                git branch: 'T053', url: 'https://github.com/vrushtiij/DevOps.git'
            }
        }

        stage('Setup MySQL') {
            steps {
                // Pull MySQL Docker image and run container
                sh '''
                docker pull mysql:latest
                docker run --name company-mysql -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 mysql:latest
                '''
            }
        }

        stage('Run SQL') {
            steps {
                // Copy your SQL file into the container and execute it
                sh '''
                docker cp db/init.sql company-mysql:/init.sql
                docker exec -i company-mysql mysql -uroot -proot < /init.sql
                '''
            }
        }
    }
}
