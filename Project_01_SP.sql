

use visit_management;
go


create procedure stp_add_visit
    @patient_id int,
    @doctor_id int,
    @visit_type_id int,
    @visit_datetime datetime,
    @duration_minutes int
as
begin
    set nocount on;

    -- check for conflict (±30 minutes for same patient)
    if exists (
        select 1 from visits
        where patient_id = @patient_id
        and abs(datediff(minute, visit_datetime, @visit_datetime)) <= 30
    )
    begin
        raiserror('conflict: patient has another visit within 30 minutes', 16, 1);
        return;
    end

    declare @fee decimal(10,2);
    select @fee = fee_amount from fee_schedule where visit_type_id = @visit_type_id;

    insert into visits (patient_id, doctor_id, visit_type_id, visit_datetime, duration_minutes, fee)
    values (@patient_id, @doctor_id, @visit_type_id, @visit_datetime, @duration_minutes, @fee);
end
go


create procedure stp_update_visit
    @visit_id int,
    @patient_id int,
    @doctor_id int,
    @visit_type_id int,
    @visit_datetime datetime,
    @duration_minutes int
as
begin
    set nocount on;

    if exists (
        select 1 from visits
        where patient_id = @patient_id
        and visit_id <> @visit_id
        and abs(datediff(minute, visit_datetime, @visit_datetime)) <= 30
    )
    begin
        raiserror('conflict: patient has another visit within 30 minutes', 16, 1);
        return;
    end

    declare @fee decimal(10,2);
    select @fee = fee_amount from fee_schedule where visit_type_id = @visit_type_id;

    update visits
    set patient_id = @patient_id,
        doctor_id = @doctor_id,
        visit_type_id = @visit_type_id,
        visit_datetime = @visit_datetime,
        duration_minutes = @duration_minutes,
        fee = @fee
    where visit_id = @visit_id;
end
go

-- sp: delete visit
create procedure stp_delete_visit
    @visit_id int
as
begin
    delete from visits where visit_id = @visit_id;
end
go


create procedure stp_list_visits_by_doctor_date
    @doctor_id int,
    @start_date datetime,
    @end_date datetime
as
begin
    select v.visit_id,
           p.patient_name,
           d.doctor_name,
           vt.type_name as visit_type,
           v.visit_datetime,
           v.duration_minutes,
           v.fee
    from visits v
    join patients p on v.patient_id = p.patient_id
    join doctors d on v.doctor_id = d.doctor_id
    join visit_types vt on v.visit_type_id = vt.visit_type_id
    where v.doctor_id = @doctor_id
      and v.visit_datetime between @start_date and @end_date
    order by v.visit_datetime;
end
go
