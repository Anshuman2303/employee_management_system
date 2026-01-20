
BEGIN
   DBMS_SCHEDULER.create_job (
      job_name        => 'monthly_salary_report',
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'BEGIN report_pkg.dept_salary_report; END;',
      start_date      => SYSTIMESTAMP,
      repeat_interval => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=0; BYMINUTE=0; BYSECOND=0',
      enabled         => TRUE
   );
END;
/
