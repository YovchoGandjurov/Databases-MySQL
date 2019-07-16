CREATE DATABASE buhtig;
USE buhtig;


# Section 1: Data Definition Language (DDL) – 40 pts

CREATE TABLE users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL
);


CREATE TABLE repositories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);


CREATE TABLE repositories_contributors (
	repository_id INT,
    contributor_id INT,
    CONSTRAINT fk_repositories_users_repo
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_repositories_users_user
    FOREIGN KEY (contributor_id) REFERENCES users(id)
);


CREATE TABLE issues (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    issue_status VARCHAR(6) NOT NULL,
    repository_id INT NOT NULL,
    assignee_id INT NOT NULL,
    CONSTRAINT fk_issues_repos
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_issues_users
    FOREIGN KEY (assignee_id) REFERENCES users(id)
);


CREATE TABLE commits (
	id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    issue_id INT,
    repository_id INT NOT NULL,
    contributor_id INT NOT NULL,
    CONSTRAINT fk_commits_issues
    FOREIGN KEY (issue_id) REFERENCES issues(id),
    CONSTRAINT fk_commits_repos
    FOREIGN KEY (repository_id) REFERENCES repositories(id),
    CONSTRAINT fk_commits_users
    FOREIGN KEY (contributor_id) REFERENCES users(id)
);


CREATE TABLE files (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    size DECIMAL(10, 2) NOT NULL,
    parent_id INT,
    commit_id INT NOT NULL,
    CONSTRAINT fk_files_parents
    FOREIGN KEY (parent_id) REFERENCES files(id),
    CONSTRAINT fk_files_commits
    FOREIGN KEY (commit_id) REFERENCES commits(id)
);



# Section 2: Data Manipulation Language (DML) – 30 pts

# 02. Data Insertion

INSERT INTO issues (title, issue_status, repository_id, assignee_id)
SELECT
	CONCAT('Critical Problem With ', f.name, '!') AS title,
    'open' AS issue_status,
    CEILING(f.id* 2 / 3) AS repository_id,
    c.contributor_id AS assignee_id
FROM files f
JOIN commits c
ON c.id = f.commit_id
WHERE f.id BETWEEN 46 AND 50;
	


#03. Data Update
# UPDATE 


# 04. Data Deletion
DELETE FROM repositories
WHERE id NOT IN (
	SELECT repository_id FROM issues
);







































































