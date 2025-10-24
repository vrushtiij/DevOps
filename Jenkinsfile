pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pull the repo
                git branch: 'T053', url: 'https://github.com/vrushtiij/DevOps.git'
            }
        }

        stage('Run MySQL SQL File') {
            steps {
                // Run your SQL script on Windows
                bat '"C:\\Program Files\\MySQL\\MySQL Server 8.0\\bin\\mysql.exe" -u root -pYourPassword Company < "C:\\Users\\Arya Rai\\OneDrive\\Desktop\\DevOps\\db\\init.sql"'
            }
        }

        stage('Demo Git Commands') {
            steps {
                // Demo push/pull (you can adjust for your own changes)
                bat 'echo "This is a demo file for T053" > demo\\demo_file.txt'
                bat 'git add demo\\demo_file.txt'
                bat 'git commit -m "Updated demo file from Jenkins pipeline"'
                bat 'git push origin T053'
            }
        }
    }
}
