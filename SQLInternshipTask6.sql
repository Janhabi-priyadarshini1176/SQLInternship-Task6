USE EyeHospitalDB;

--Scalar Subquery
-- Find the doctor with the highest number of appointments
SELECT D.Name
FROM Doctors D
WHERE D.DoctorID = (
  SELECT TOP 1 A.DoctorID
  FROM Appointments A
  GROUP BY A.DoctorID
  ORDER BY COUNT(*) DESC
);

--Correlated Subquery
-- Find doctors who have more appointments than the average doctor
SELECT D.Name
FROM Doctors D
WHERE (
  SELECT COUNT(*)
  FROM Appointments A
  WHERE A.DoctorID = D.DoctorID
) > (
  SELECT AVG(AppointmentCount)
  FROM (
    SELECT DoctorID, COUNT(*) AS AppointmentCount
    FROM Appointments
    GROUP BY DoctorID
  ) AS Subquery
);

--Subquery with IN
-- Find patients who have appointments with doctors in the "Cardiology" department
SELECT P.Name
FROM Patients P
WHERE P.PatientID IN (
  SELECT A.PatientID
  FROM Appointments A
  JOIN Doctors D ON A.DoctorID = D.DoctorID
  WHERE D.Specialty = 'Cardiology'
);

--Subquery with EXISTS
-- Find doctors who have at least one appointment
SELECT D.Name
FROM Doctors D
WHERE EXISTS (
  SELECT 1
  FROM Appointments A
  WHERE A.DoctorID = D.DoctorID
);

--Subquery in FROM clause
-- Find the top 5 doctors with the most appointments
SELECT *
FROM (
  SELECT TOP 5 D.Name, COUNT(*) AS AppointmentCount
  FROM Doctors D
  JOIN Appointments A ON D.DoctorID = A.DoctorID
  GROUP BY D.Name
  ORDER BY AppointmentCount DESC
) AS Subquery;
