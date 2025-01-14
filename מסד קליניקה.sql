USE [Clinic]
GO
/****** Object:  UserDefinedFunction [dbo].[priceAfterSale]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[priceAfterSale](@idTest smallint)
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
			if (select [Insurance] from [dbo].[Client] where [Client].[id]=@idClient)='שיא'
				set @price=(select ti.[price] from TestsID ti join Tests t on ti.id= t.IdTest where t.Id = @idTest)*0.7
			else
				set @price=(select ti.[price] from TestsID ti join Tests t on ti.id= t.IdTest where t.Id = @idTest)*0.5
			 if @price+@temp>2000
				 set @price=2000-@temp
		end
    end  
   return @price
end
GO
/****** Object:  UserDefinedFunction [dbo].[table_price1]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[table_price1](@getdate date)
	returns @table_price2 table(
	id_test smallint ,
	id_client smallint,
	date_test date,
	price int

	)
	as
	begin
	insert into @table_price2
	select id,idClient,date,price from Tests
	where DATEDIFF(month,date,@getdate)=0
	order by idClient
	return 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[table_price12]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[table_price12](@getdate date)
	returns @table_price22 table(
	id_test smallint ,
	id_client smallint,
	date_test date,
	price int,
	ample int 

	)
	as
	begin
	insert into @table_price22
	select id,idClient,date,price ,null from Tests
	where DATEDIFF(month,date,@getdate)=0
	order by idClient
	return 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[table_priceA]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[table_priceA](@getdate date)
	returns @table_priceA1 table(
	id_client smallint,
	sumAmple int 
	)
	as
	begin
	insert into @table_priceA1
	select distinct idClient ,sum(ample) from Tests
	where DATEDIFF(month,date,@getdate)=0
	group by idClient
	return 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[table_priceB]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create function [dbo].[table_priceB](@getdate date)
	returns @table_priceA1 table(
	id_client smallint,
	sumAmple int 
	)
	as
	begin
	insert into @table_priceA1
	select distinct idClient ,sum(ample) from Tests
	where DATEDIFF(month,date,@getdate)=0
	group by idClient
	return 
	end
GO
/****** Object:  UserDefinedFunction [dbo].[table_priceD]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[table_priceD](@getdate date)
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
GO
/****** Object:  Table [dbo].[Doctors]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctors](
	[id] [smallint] IDENTITY(300,1) NOT NULL,
	[Name] [varchar](20) NULL,
	[phone] [varchar](10) NULL,
	[IdProfession] [smallint] NULL,
	[seniority] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[doctorForClient1]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[doctorForClient1]
as
select [id],[Name],[IdProfession],[seniority] from Doctors
GO
/****** Object:  View [dbo].[doctorForClient]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[doctorForClient]
as
select [id],[Name],[IdProfession],[seniority] from Doctors
GO
/****** Object:  Table [dbo].[Tests]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tests](
	[id] [smallint] IDENTITY(500,1) NOT NULL,
	[idClient] [int] NOT NULL,
	[IdTest] [smallint] NOT NULL,
	[IdApplication] [smallint] NOT NULL,
	[date] [date] NULL,
	[city] [varchar](20) NULL,
	[price] [int] NULL,
	[ample] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[idClient] ASC,
	[IdTest] ASC,
	[IdApplication] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[table_price]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	create function [dbo].[table_price](@getdate date)
	returns table as
	return (select id,idClient, date,price from Tests
	where DATEDIFF(month,date,@getdate)=0 
	)
GO
/****** Object:  Table [dbo].[Application]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Application](
	[id] [smallint] IDENTITY(400,1) NOT NULL,
	[IdClient] [int] NULL,
	[IdDoctor] [smallint] NULL,
	[topic] [varchar](40) NULL,
	[IdTest] [smallint] NULL,
	[date] [date] NULL,
	[summary_visit] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[id] [int] IDENTITY(326239548,10) NOT NULL,
	[FirstName] [varchar](20) NULL,
	[lastName] [varchar](20) NULL,
	[sex] [varchar](1) NULL,
	[phone] [varchar](10) NULL,
	[birthDate] [date] NULL,
	[street] [varchar](20) NULL,
	[city] [varchar](20) NULL,
	[Insurance] [varchar](10) NULL,
	[enotheSale] [varchar](50) NULL,
 CONSTRAINT [PK__Client__3213E83F60E599EA] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProfessionID]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfessionID](
	[id] [smallint] IDENTITY(100,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestsID]    Script Date: 25/04/2023 15:17:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestsID](
	[id] [smallint] IDENTITY(200,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[price] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Application] ON 

INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (400, 326239548, 300, N'כאבי ראש', 200, CAST(N'2023-02-05' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (401, 326239558, 301, N'לחץ בחזה', 202, CAST(N'2000-05-06' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (402, 326239568, 302, N'עששת', 204, CAST(N'2005-12-30' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (403, 326239578, 300, N'כאבי ראש', 200, CAST(N'2009-10-10' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (404, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-10-10' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (405, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-11-10' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (406, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-11-10' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (408, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-12-10' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (409, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-12-01' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (410, 326239548, 300, N'כאבי ראש ', 200, CAST(N'2009-12-11' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (411, 326239548, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (412, 326239548, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (413, 326239548, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (414, 326239548, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (415, 326239548, 300, N'כאבי ראש', 200, CAST(N'2009-12-15' AS Date), NULL)
INSERT [dbo].[Application] ([id], [IdClient], [IdDoctor], [topic], [IdTest], [date], [summary_visit]) VALUES (416, 326239548, 300, N'כאבי ראש', 200, CAST(N'2009-12-17' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[Application] OFF
GO
SET IDENTITY_INSERT [dbo].[Client] ON 

INSERT [dbo].[Client] ([id], [FirstName], [lastName], [sex], [phone], [birthDate], [street], [city], [Insurance], [enotheSale]) VALUES (326239548, N'שרה', N'כהן', N'נ', N'0545454541', CAST(N'2001-05-12' AS Date), N'גולומב', N'ירושלים', N'עדיף', NULL)
INSERT [dbo].[Client] ([id], [FirstName], [lastName], [sex], [phone], [birthDate], [street], [city], [Insurance], [enotheSale]) VALUES (326239558, N'יעקב', N'לוי', N'ז', N'0154787825', CAST(N'1999-08-23' AS Date), N'סאלח א-דין', N'ירושלים', N'שיא', NULL)
INSERT [dbo].[Client] ([id], [FirstName], [lastName], [sex], [phone], [birthDate], [street], [city], [Insurance], [enotheSale]) VALUES (326239568, N'משה', N'דוידוביץ', N'ז', N'0458745892', CAST(N'2003-07-12' AS Date), N'ברכת אברהם', N'בני ברק', N'שיא', NULL)
INSERT [dbo].[Client] ([id], [FirstName], [lastName], [sex], [phone], [birthDate], [street], [city], [Insurance], [enotheSale]) VALUES (326239578, N'חיה', N'לוי', N'נ', N'2852552002', CAST(N'2000-10-14' AS Date), N'נעהכב', N'ךתלצחמ', N'שיא', NULL)
SET IDENTITY_INSERT [dbo].[Client] OFF
GO
SET IDENTITY_INSERT [dbo].[Doctors] ON 

INSERT [dbo].[Doctors] ([id], [Name], [phone], [IdProfession], [seniority]) VALUES (300, N'אלכס', N'0654554124', 100, 11)
INSERT [dbo].[Doctors] ([id], [Name], [phone], [IdProfession], [seniority]) VALUES (301, N'טטיאנה', N'0545455698', 101, 13)
INSERT [dbo].[Doctors] ([id], [Name], [phone], [IdProfession], [seniority]) VALUES (302, N'יבגניה', N'0545455697', 102, 5)
INSERT [dbo].[Doctors] ([id], [Name], [phone], [IdProfession], [seniority]) VALUES (303, N'מיכאל', N'0545455678', 103, 20)
SET IDENTITY_INSERT [dbo].[Doctors] OFF
GO
SET IDENTITY_INSERT [dbo].[ProfessionID] ON 

INSERT [dbo].[ProfessionID] ([id], [Name]) VALUES (100, N'נוירולוגיה')
INSERT [dbo].[ProfessionID] ([id], [Name]) VALUES (101, N'קרדיאולוגיה')
INSERT [dbo].[ProfessionID] ([id], [Name]) VALUES (102, N'אורטודנטיה')
INSERT [dbo].[ProfessionID] ([id], [Name]) VALUES (103, N'פסיכאטריה')
INSERT [dbo].[ProfessionID] ([id], [Name]) VALUES (104, N'גנקולוגיה')
SET IDENTITY_INSERT [dbo].[ProfessionID] OFF
GO
SET IDENTITY_INSERT [dbo].[Tests] ON 

INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (500, 326239548, 200, 400, CAST(N'2023-02-10' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (513, 326239548, 200, 404, CAST(N'2009-10-10' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (514, 326239548, 200, 405, CAST(N'2009-11-10' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (515, 326239548, 200, 406, CAST(N'2009-11-10' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (516, 326239548, 200, 408, CAST(N'2009-12-10' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (517, 326239548, 200, 409, CAST(N'2009-12-01' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (526, 326239548, 200, 409, CAST(N'2009-12-25' AS Date), N'ירושלים', 550, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (532, 326239548, 200, 409, CAST(N'2009-12-25' AS Date), N'ירושלים', 350, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (533, 326239548, 200, 409, CAST(N'2009-12-25' AS Date), N'ירושלים', 0, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (534, 326239548, 200, 409, CAST(N'2009-12-25' AS Date), N'ירושלים', 0, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (518, 326239548, 200, 410, CAST(N'2009-12-20' AS Date), N'ירושלים', 0, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (519, 326239548, 200, 415, CAST(N'2009-12-25' AS Date), N'ירושלים', 0, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (520, 326239548, 200, 416, CAST(N'2009-12-25' AS Date), N'ירושלים', 0, 500)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (510, 326239558, 202, 401, CAST(N'2000-05-12' AS Date), N'ירושלים', 630, 270)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (521, 326239558, 202, 401, CAST(N'2000-05-12' AS Date), N'ירושלים', 630, 270)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (522, 326239558, 202, 401, CAST(N'2000-05-12' AS Date), N'ירושלים', 630, 270)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (525, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, 300)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (527, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, 300)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (528, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, 300)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (529, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (530, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (531, 326239568, 200, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 770, NULL)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (524, 326239568, 203, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 1400, 600)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (511, 326239568, 204, 402, CAST(N'2009-12-25' AS Date), N'בני ברק', 70, 30)
INSERT [dbo].[Tests] ([id], [idClient], [IdTest], [IdApplication], [date], [city], [price], [ample]) VALUES (523, 326239568, 204, 402, CAST(N'2006-01-10' AS Date), N'בני ברק', 70, 30)
SET IDENTITY_INSERT [dbo].[Tests] OFF
GO
SET IDENTITY_INSERT [dbo].[TestsID] ON 

INSERT [dbo].[TestsID] ([id], [Name], [price]) VALUES (200, N'MRI', 1100)
INSERT [dbo].[TestsID] ([id], [Name], [price]) VALUES (201, N'ct', 500)
INSERT [dbo].[TestsID] ([id], [Name], [price]) VALUES (202, N'ekg', 900)
INSERT [dbo].[TestsID] ([id], [Name], [price]) VALUES (203, N'mmse', 2000)
INSERT [dbo].[TestsID] ([id], [Name], [price]) VALUES (204, N'x-rays', 100)
SET IDENTITY_INSERT [dbo].[TestsID] OFF
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD  CONSTRAINT [FK__Applicati__IdCli__2D27B809] FOREIGN KEY([IdClient])
REFERENCES [dbo].[Client] ([id])
GO
ALTER TABLE [dbo].[Application] CHECK CONSTRAINT [FK__Applicati__IdCli__2D27B809]
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD FOREIGN KEY([IdDoctor])
REFERENCES [dbo].[Doctors] ([id])
GO
ALTER TABLE [dbo].[Application]  WITH CHECK ADD FOREIGN KEY([IdTest])
REFERENCES [dbo].[TestsID] ([id])
GO
ALTER TABLE [dbo].[Doctors]  WITH CHECK ADD FOREIGN KEY([IdProfession])
REFERENCES [dbo].[ProfessionID] ([id])
GO
ALTER TABLE [dbo].[Tests]  WITH CHECK ADD FOREIGN KEY([IdApplication])
REFERENCES [dbo].[Application] ([id])
GO
ALTER TABLE [dbo].[Tests]  WITH CHECK ADD FOREIGN KEY([idClient])
REFERENCES [dbo].[Client] ([id])
GO
ALTER TABLE [dbo].[Tests]  WITH CHECK ADD FOREIGN KEY([IdTest])
REFERENCES [dbo].[TestsID] ([id])
GO
/****** Object:  StoredProcedure [dbo].[addPriceAfterSale]    Script Date: 25/04/2023 15:17:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[addPriceAfterSale] as
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
GO
/****** Object:  StoredProcedure [dbo].[update_ample]    Script Date: 25/04/2023 15:17:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[update_ample]
	as
	begin
			declare @temp smallint
			declare crs CURSOR
			for select idClient from [dbo].[Tests]
			open crs
			fetch next from crs into @temp
			while  @@fetch_status is null 
			begin
			update Tests
			set ample= (select ([dbo].[TestsID].[price]-Tests.price)from TestsID join Tests on TestsID.id= Tests.id
			where DATEDIFF(month,date,getdate())=0)
				fetch next from crs
			into @temp
			end
			close crs
			deallocate crs 
			end
GO
/****** Object:  StoredProcedure [dbo].[update_ample1]    Script Date: 25/04/2023 15:17:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[update_ample1]
	as
	begin
			declare @temp smallint
			declare crs CURSOR
			for select idClient from [dbo].[Tests]
			open crs
			fetch next from crs into @temp
			while  @@fetch_status is null 
			begin
			update Tests
			set ample= (select ([dbo].[TestsID].[price]-Tests.price)from TestsID join Tests on TestsID.id= Tests.id
			where DATEDIFF(month,date,getdate())=0)
				fetch next from crs
			into @temp
			end
			close crs
			deallocate crs 
			end
GO
/****** Object:  StoredProcedure [dbo].[update_ampleA]    Script Date: 25/04/2023 15:17:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[update_ampleA]
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
GO
