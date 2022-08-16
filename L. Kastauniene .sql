/* Main info about the columns of a prepaid customer base:
-- account_id - unique SIM / Client ID
-- msisdn - phone number of the client
-- activation_date - service activation date
-- deletion_date - service deactivation date
-- status - the newest/current status of the service/client
-- imei_a - unique phone/device ID (IMEI).
-- device_brand - Phone brand
-- device_model - Phone model
-- device_type - Phone type */

-- TASKS:
-- 1) Query by which you could extract active clients at the 2013-06-19.
select * from sandbox_activations
where status = 'active' and activation_date like '2013-06-19%';

-- 2) How many clients were activated and deactivated during June of 2013. Please provide
-- both numbers as a result of one query.
select count(status) as count, status from sandbox_activations
where activation_date like '2013-06%' or deletion_date like '2013-06%'
group by status
having status = 'active' or status = 'deactivated';

-- 3) How many active clients had more than one SIM card on 2013-06-19. Unique client
-- could be identified by using unique device information (prepaid customers are usually not
-- identified in the systems).
select count(count) as total from (select count(*) as count, imei_a from sandbox_activations
where activation_date between 0 and '2013-06-19%' and status like 'active'
group by imei_a
having imei_a not in (0,'') and count > 1) as TOTAL;

-- 4) Select currently active clients and pick up TOP5 device brands by each phone type.
-- Please provide the result in one single query.
select count(*) as vnt, device_brand from sandbox_activations
group by device_brand
having device_brand not like ''
order by vnt DESC
limit 5;

-- 5) Request is to provide a new column for currently active clients. New column should have
-- the value of IMEI if the client is the first who used this IMEI (you can check by the client
-- activation date). If the client is not the first one, then column value should be 'Multi SIM'.

select count(imei_a) as 'phone numbers count for the same Imei',imei_a,
case
when count(imei_a) = 1 then imei_a
else 'MULTI SIM'
end as 'first/multi'
from sandbox_activations
where status = 'active'
GROUP BY imei_a;
