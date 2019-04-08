
create trigger tbMRODatains on tbMROData
instead of insert
as
begin
	declare @ts  nvarchar(50), @ss nvarchar(50), @is nvarchar(50), @cnt int
	declare @lsr float, @lnr float, @lne int, @lnp smallint
	declare cur cursor for
	select * from inserted
	open cur
	fetch next from cur into @ts, @ss, @is, @lsr, @lnr, @lne, @lnp
	while @@fetch_status  = 0
	begin
		select @cnt = count(*) from tbMROData where tbMROData.TimeStamp = @ts and tbMROData.ServingSector = @ss and tbMROData.InterferingSector = @is
		if(@cnt < 1) 
		begin 
			insert into tbMROData values(@ts, @ss, @is, @lsr, @lnr, @lne, @lnp)
		end
		fetch next from cur into @ts, @ss, @is, @lsr, @lnr, @lne, @lnp
	end
	close cur
	deallocate cur
end


/*
create trigger tbMRODatains2 on tbMROData
instead of insert
as 
begin
	declare @ts  nvarchar(50), @ss nvarchar(50), @is nvarchar(50), @cnt int
	select @ts = TimeStamp, @ss = ServingSector, @is = InterferingSector from inserted
	select @cnt = count(*) from tbMROData where tbMROData.TimeStamp = @ts and tbMROData.ServingSector = @ss and tbMROData.InterferingSector = @is
	if(@cnt < 1)
	begin
		insert into tbMROData select * from inserted
	end
end
*/ 