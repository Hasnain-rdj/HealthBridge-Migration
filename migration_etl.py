# migration_etl.py - Load legacy CSV into refactored appointments schema
import csv
import mysql.connector
from datetime import datetime

VALID_STATUSES = {'P', 'C', 'X', 'H', 'R'}

# Mapper to align legacy codes with our new strict Prisma Enum
STATUS_MAP = {'P': 'PENDING', 'C': 'COMPLETE', 'X': 'CANCEL', 'H': 'HOLD', 'R': 'RESCHEDULED'}

def parse_appt_date(raw):
    # T1: 'DD/MM/YYYY HH:MM' --> 'YYYY-MM-DD HH:MM:SS' (Proper MySQL DATETIME)
    dt_obj = datetime.strptime(raw, '%d/%m/%Y %H:%M')
    return dt_obj.strftime('%Y-%m-%d %H:%M:%S')

def split_room(raw):
    # T2: 'Room 3 Block B' --> (3, 'Block B')
    # Strip 'Room ' from the start, then split on the first space
    stripped = raw.replace('Room ', '')
    room_no, block = stripped.split(' ', 1)
    return int(room_no), block

def migrate(csv_path, db_config):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    skipped = []

    # Disable FK checks temporarily for ETL load to prevent orphan errors 
    # since we haven't imported the doctors/patients tables yet.
    cursor.execute("SET FOREIGN_KEY_CHECKS=0;")

    with open(csv_path, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            
            # T4: validate status; skip and log unknown codes
            if row['status'] not in VALID_STATUSES:
                skipped.append(row['appt_id'])
                continue

            appt_dt = parse_appt_date(row['appt_date'])   # T1
            room_no, block = split_room(row['room'])      # T2
            strict_status = STATUS_MAP[row['status']]     # Map to Enum

            # T3: patient_nm, patient_ph, doc_name intentionally omitted
            cursor.execute(
                '''INSERT INTO Appointment 
                   (id, patientId, doctorId, date, status, fee, discount, roomNumber, blockName)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)''',
                (row['appt_id'], row['patient_id'], row['doc_id'],
                 appt_dt, strict_status, row['fee'], row['discount'],
                 str(room_no), block)
            )

    conn.commit()
    cursor.execute("SET FOREIGN_KEY_CHECKS=1;") # Re-enable strict relations
    
    print(f'Done. Skipped {len(skipped)} rows with invalid status: {skipped}')
    cursor.close()
    conn.close()

# Connection config pointing to your local Docker container
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'admin123',
    'database': 'healthbridge',
    'port': 3306
}

if __name__ == '__main__':
    migrate('legacy_appointments.csv', db_config)