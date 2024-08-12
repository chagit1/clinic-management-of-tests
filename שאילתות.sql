--����� ���� ����� ������ ���� ���� ��� ���� ������� 
create view doctorForClient
	as
	select [id],[Name],[IdProfession],[seniority] from Doctors

-- �������� ��� ������ �� ���� ������ 
alter procedure addPriceAfterSale as
	begin
		begin
		declare @x smallint
			declare @temp smallint
			declare crs CURSOR
			for select id from [dbo].[Tests]
			open crs
			fetch next from crs into @temp
			while @@fetch_status=0 
			begin 
			--set @temp=(select Tests.IdTest from Tests where Tests.id=@temp)
				UPDATE [dbo].[Tests]
				set price= dbo.priceAfterSale(@temp)
				where Tests.id=@temp
				fetch next from crs
				into @temp
			end
			close crs
			deallocate crs 
		end
	end
exec  addPriceAfterSale 

--����� ������ ��� ����� ������� ����� ������ �����
-- �� ����� ���� ����� �� ��� ����� ����� ����� ���� ��� ���� 
alter trigger updetePriceSelf3 on [dbo].[Tests]
	for insert 
	as
	begin
	declare @tId int 
	select @tid=inserted.id from inserted
		update Tests
		set price = dbo.PriceAfterSale(@tid)
		where id = @tid
	end
--������� ������ ��� ����� ������ ������ �� ���� ������ �"� ����� �� ��� �����
-- ������ ����� ����� �� ����� ������� ������ ����
alter function PriceAfterSale(@idTest smallint)
returns int
as
begin
    declare @price int
    declare @idClient int
    select @idClient = idClient from Tests where Id = @idTest;
	declare @temp int
	begin
		select @temp= (select sum(price) from Tests where idClient=@idClient and datediff(month, [date],'2009-12-30')=0)
        if @temp>=2000
			set @price=0
		else
			begin
			if (select [Insurance] from [dbo].[Client] where [Client].[id]=@idClient)='���'
				set @price=(select ti.[price] from TestsID ti join Tests t on ti.id= t.IdTest where t.Id = @idTest)*0.7
			else
				set @price=(select ti.[price] from TestsID ti join Tests t on ti.id= t.IdTest where t.Id = @idTest)*0.5
			 if @price+@temp>2000
				 set @price=2000-@temp
		end
    end  
   return @price
end

-- ������� ����� ������ �� ���� ������� ����� ����� ����� 
alter function table_priceD(@getdate date)
returns @table_priceA1 table
(
id_client int,
sumAmple int)
as
begin
	insert into @table_priceA1
	select distinct idClient ,sum(ample) from Tests
	where DATEDIFF(month,date,@getdate)=0
	group by idClient
	return 
end
	go
	select * from table_priceD('2009-12-30')

--�������� ������� ����� ����� �� ������� �� ��� ������ ������� ���  
alter procedure update_ampleA
as
begin
	declare @temp smallint
	declare crs CURSOR
	for select Tests.id from [dbo].[Tests]
	where ample is null
	for update 
	open crs
	fetch next from crs into @temp
	while  @@fetch_status =0
		begin
			update Tests
			set ample =(
			select ([dbo].[TestsID].[price]-Tests.price)from TestsID join Tests on TestsID.id= Tests.IdTest
			where Tests.id=@temp)
			where Tests.id=@temp
			fetch next from crs
			into @temp
		end
	close crs
	deallocate crs 
end
	exec update_ampleA

--(row-number) ���� ������ ������ ��� ���� ����� �"� ����� ���� ������ ������ �������
select top(1)*from(select ROW_NUMBER() over(order by id)as maxTest,*
from Tests )q

