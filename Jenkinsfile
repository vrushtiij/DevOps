pipeline {
    agent any

    environment {
        MYSQL_ROOT_PASSWORD = 'root'
        MYSQL_CONTAINER_NAME = 'mysql-temp'
        MYSQL_IMAGE = 'mysql:8.0.36-oracle'
    }

    stages {
        stage('Run MySQL and Execute Queries') {
            steps {
                echo " Starting temporary MySQL container with full logging..."
                sh '''
                # Remove old container if it exists
                docker rm -f ${MYSQL_CONTAINER_NAME} || true

                # Create init SQL file
                cat <<EOF > init.sql
-- Create database and table
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE IF NOT EXISTS employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO employee (name, position, salary) VALUES ('Alice','Manager',75000);
INSERT INTO employee (name, position, salary) VALUES ('Bob','Developer',55000);
INSERT INTO employee (name, position, salary) VALUES ('Charlie','Analyst',50000);
EOF

                # Run MySQL container
                docker run --name ${MYSQL_CONTAINER_NAME} \
                    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                    -v $(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql:ro \
                    -d ${MYSQL_IMAGE}

                # Wait until MySQL is ready
                echo "Waiting for MySQL to initialize..."
                until docker exec ${MYSQL_CONTAINER_NAME} mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1;" >/dev/null 2>&1; do
                    echo " MySQL not ready yet, retrying in 2 seconds..."
                    sleep 2
                done
                echo " MySQL is ready!"

                # Show table before deletion
                echo " Records before deletion:"
                docker exec ${MYSQL_CONTAINER_NAME} mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "USE company; SELECT * FROM employee;"

                # Delete one record
                echo " Deleting employee 'Bob'..."
                docker exec ${MYSQL_CONTAINER_NAME} mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "USE company; DELETE FROM employee WHERE name='Bob';"

                # Show table after deletion
                echo " Records after deletion:"
                docker exec ${MYSQL_CONTAINER_NAME} mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "USE company; SELECT * FROM employee;"

                # Remove container to free memory
                docker rm -f ${MYSQL_CONTAINER_NAME}
                echo " MySQL container removed. All queries executed."
                '''
            }
        }
    }
}
