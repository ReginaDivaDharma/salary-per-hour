import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime

engine = create_engine('postgresql://postgres:Bobi%402024@localhost:5433/mekari')

employees_file_path = r'C:\Users\Administrator\Desktop\IT Projects\Mekari - Salary Per Hour\Data\employees_cleaned.csv'
timesheets_file_path = r'C:\Users\Administrator\Desktop\IT Projects\Mekari - Salary Per Hour\Data\timesheets_cleaned.csv'

employees = pd.read_csv(employees_file_path)
timesheets = pd.read_csv(timesheets_file_path)

timesheets['checkin'] = pd.to_datetime(timesheets['checkin'])
timesheets['checkout'] = pd.to_datetime(timesheets['checkout'])

timesheets = pd.merge(timesheets, employees[['employee_id', 'branch_id']], on='employee_id', how='left')

last_load_query = """
    SELECT year, month
    FROM payroll.salary_per_hour
    ORDER BY year DESC, month DESC
    LIMIT 1;
"""
result = pd.read_sql(last_load_query, engine)

if result.empty:
    last_load_year = 1900  
    last_load_month = 1     
else:
    last_load_year = result['year'].iloc[0]
    last_load_month = result['month'].iloc[0]

new_timesheets = timesheets[timesheets['checkin'].dt.year > last_load_year]
new_timesheets = new_timesheets[new_timesheets['checkin'].dt.month > last_load_month]

new_timesheets.loc[:, 'hours_worked'] = (new_timesheets['checkout'] - new_timesheets['checkin']).dt.total_seconds() / 3600

total_hours = new_timesheets.groupby(['branch_id', new_timesheets['checkin'].dt.year, new_timesheets['checkin'].dt.month, 'employee_id'])['hours_worked'].sum().reset_index()
total_hours.columns = ['branch_id', 'year', 'month', 'employee_id', 'total_hours']

merged_data = pd.merge(total_hours, employees, on='employee_id')

merged_data['salary_per_hour'] = merged_data['salary'] / merged_data['total_hours']

final_data = merged_data[['year', 'month', 'branch_id', 'salary_per_hour']]

final_data.to_sql('salary_per_hour', engine, if_exists='append', index=False)

print(f"Load completed successfully. {len(final_data)} new records inserted.")
