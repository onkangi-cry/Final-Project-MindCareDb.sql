-- Create the database
CREATE DATABASE IF NOT EXISTS MindCareDB;
USE MindCareDB;

-- Users Table (can be both patients or therapists)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('patient', 'therapist') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Therapists Table (Extra data specific to therapists)
CREATE TABLE Therapists (
    therapist_id INT PRIMARY KEY,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    specialization VARCHAR(100),
    years_experience INT,
    FOREIGN KEY (therapist_id) REFERENCES Users(user_id)
);

-- Sessions Table (Therapy appointments)
CREATE TABLE Sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    therapist_id INT NOT NULL,
    session_date DATETIME NOT NULL,
    notes TEXT,
    status ENUM('scheduled', 'completed', 'cancelled') DEFAULT 'scheduled',
    FOREIGN KEY (patient_id) REFERENCES Users(user_id),
    FOREIGN KEY (therapist_id) REFERENCES Users(user_id)
);

-- Journals Table (Patient self-entries)
CREATE TABLE Journals (
    journal_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    entry_date DATE NOT NULL,
    title VARCHAR(100),
    content TEXT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Users(user_id)
);

-- Mood Logs Table (Mood tracking)
CREATE TABLE Mood_Logs (
    mood_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    mood_level INT CHECK (mood_level BETWEEN 1 AND 10),
    mood_note TEXT,
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Users(user_id)
);

-- Diagnoses Table (Mental health conditions)
CREATE TABLE Diagnoses (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    therapist_id INT NOT NULL,
    diagnosis VARCHAR(255),
    diagnosis_date DATE NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Users(user_id),
    FOREIGN KEY (therapist_id) REFERENCES Users(user_id)
);

-- Treatments Table (Therapy/plan linked to diagnosis)
CREATE TABLE Treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_id INT NOT NULL,
    treatment_description TEXT NOT NULL,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnoses(diagnosis_id)
);

-- Messages Table (Chat between therapist and patient)
CREATE TABLE Messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message TEXT NOT NULL,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

-- Session Feedback Table
CREATE TABLE Session_Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES Sessions(session_id)
);

-- 🌱 Sample Data
INSERT INTO Users (full_name, email, password_hash, role) VALUES
('Alice Monroe', 'alice@example.com', 'hashed_pw1', 'patient'),
('Dr. John Smith', 'drsmith@example.com', 'hashed_pw2', 'therapist'),
('Brian Gomez', 'brian@example.com', 'hashed_pw3', 'patient'),
('Dr. Lila Chang', 'drlila@example.com', 'hashed_pw4', 'therapist');

INSERT INTO Therapists (therapist_id, license_number, specialization, years_experience) VALUES
(2, 'TX-THER-1122', 'Cognitive Behavioral Therapy', 10),
(4, 'NY-THER-3344', 'Trauma & PTSD', 15);

INSERT INTO Sessions (patient_id, therapist_id, session_date, notes, status) VALUES
(1, 2, '2025-05-01 10:00:00', 'Intro session, discussed anxiety triggers.', 'completed'),
(3, 4, '2025-05-03 14:00:00', 'Initial evaluation for PTSD.', 'scheduled');

INSERT INTO Journals (patient_id, entry_date, title, content) VALUES
(1, '2025-05-01', 'Feeling Hopeful', 'Today I felt better after the session.'),
(3, '2025-05-02', 'Restless Night', 'Couldn’t sleep, thoughts racing.');

INSERT INTO Mood_Logs (patient_id, mood_level, mood_note) VALUES
(1, 7, 'Felt good most of the day.'),
(3, 3, 'Lots of anxiety today.');

INSERT INTO Diagnoses (patient_id, therapist_id, diagnosis, diagnosis_date) VALUES
(1, 2, 'Generalized Anxiety Disorder', '2025-05-01'),
(3, 4, 'PTSD', '2025-05-03');

INSERT INTO Treatments (diagnosis_id, treatment_description, start_date) VALUES
(1, 'Weekly CBT sessions + mindfulness practice', '2025-05-02'),
(2, 'Trauma-focused therapy + journaling', '2025-05-04');

INSERT INTO Messages (sender_id, receiver_id, message) VALUES
(1, 2, 'Thanks for the session today!'),
(2, 1, 'You did great today! Keep journaling.');

INSERT INTO Session_Feedback (session_id, rating, comments) VALUES
(1, 5, 'Very helpful session.');
