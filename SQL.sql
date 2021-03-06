USE [master]
GO
/****** Object:  Database [FlowerNutrition]    Script Date: 2018/7/25 11:19:28 ******/
CREATE DATABASE [FlowerNutrition]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FlowerNutrition', FILENAME = N'D:\桌面\FlowerNutrition.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'FlowerNutrition_log', FILENAME = N'D:\桌面\FlowerNutrition_log.ldf' , SIZE = 15040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [FlowerNutrition] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FlowerNutrition].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FlowerNutrition] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FlowerNutrition] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FlowerNutrition] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FlowerNutrition] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FlowerNutrition] SET ARITHABORT OFF 
GO
ALTER DATABASE [FlowerNutrition] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FlowerNutrition] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [FlowerNutrition] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FlowerNutrition] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FlowerNutrition] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FlowerNutrition] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FlowerNutrition] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FlowerNutrition] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FlowerNutrition] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FlowerNutrition] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FlowerNutrition] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FlowerNutrition] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FlowerNutrition] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FlowerNutrition] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FlowerNutrition] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FlowerNutrition] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FlowerNutrition] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FlowerNutrition] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FlowerNutrition] SET RECOVERY FULL 
GO
ALTER DATABASE [FlowerNutrition] SET  MULTI_USER 
GO
ALTER DATABASE [FlowerNutrition] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FlowerNutrition] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FlowerNutrition] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FlowerNutrition] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [FlowerNutrition]
GO
/****** Object:  StoredProcedure [dbo].[CheckLogin]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[CheckLogin](
@name nvarchar(30)
)
as
declare @count int
select @count=datediff(ss,endtime,getdate()) from [dbo].[Online] where who=@name
if(@count>2)
	update [dbo].[Online] set state='离线' where who=@name
	--select 状态=case when @count>2 then '超时' when @count<=2 then '未超时' end from [dbo].[Online] where who=@name
else
	update [dbo].[Online] set state='在线' where who=@name
GO
/****** Object:  StoredProcedure [dbo].[ShopCount]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShopCount]
(
@name nvarchar(30)
)
AS
select count(*) from Shop where Shop_province in(
select Shop_province from Shop where Shop_id in (
select Shop_id from [dbo].[User] where User_admin in (@name)))


GO
/****** Object:  Table [dbo].[Auto]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Auto](
	[Auto_id] [bigint] IDENTITY(1,1) NOT NULL,
	[Auto_date] [datetime] NOT NULL,
	[Shop_id] [int] NOT NULL,
 CONSTRAINT [PK_Auto] PRIMARY KEY CLUSTERED 
(
	[Auto_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Chat]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Chat](
	[chat_id] [bigint] IDENTITY(1,1) NOT NULL,
	[chat_name] [nvarchar](50) NULL,
	[chat_txt] [text] NULL,
	[chat_time] [datetime] NULL,
 CONSTRAINT [PK_Chat] PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Consume]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Consume](
	[Cus_id] [nvarchar](150) NOT NULL,
	[Cus_detail] [text] NOT NULL,
	[Cus_money] [money] NOT NULL,
	[Ifvip] [varchar](10) NOT NULL,
	[Cus_want] [nvarchar](300) NULL,
	[Cus_time] [datetime] NOT NULL,
	[Cus_way] [nvarchar](20) NOT NULL,
	[Card_id] [bigint] NULL,
	[shop_id] [int] NOT NULL,
 CONSTRAINT [PK_Consume] PRIMARY KEY CLUSTERED 
(
	[Cus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Department]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Department_id] [nvarchar](20) NOT NULL,
	[Department_name] [nvarchar](30) NOT NULL,
	[Department_txt] [nvarchar](150) NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[Department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Food]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[Food_id] [int] IDENTITY(1,1) NOT NULL,
	[Food_name] [nvarchar](50) NOT NULL,
	[Food_sale] [money] NOT NULL,
	[Food_ka] [decimal](10, 2) NOT NULL,
	[Food_area] [nvarchar](30) NOT NULL,
	[Food_txt] [text] NOT NULL,
	[shop_id] [int] NULL,
	[FoodType_id] [int] NULL,
	[Food_pic] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Food] PRIMARY KEY CLUSTERED 
(
	[Food_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoodType]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodType](
	[FoodType_id] [int] IDENTITY(1,1) NOT NULL,
	[FoodType_name] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_FoodType] PRIMARY KEY CLUSTERED 
(
	[FoodType_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Forget]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forget](
	[Forget_id] [int] NOT NULL,
	[Forget_txt] [nvarchar](250) NOT NULL,
	[shop_id] [int] NULL,
 CONSTRAINT [PK_Forget] PRIMARY KEY CLUSTERED 
(
	[Forget_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Meal]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Meal](
	[meal_id] [int] IDENTITY(1,1) NOT NULL,
	[meal_name] [nvarchar](20) NOT NULL,
	[meal_price] [money] NULL,
 CONSTRAINT [PK_Meal] PRIMARY KEY CLUSTERED 
(
	[meal_id] ASC,
	[meal_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MealFood]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MealFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[food_id] [int] NULL,
	[meal_id] [int] NULL,
 CONSTRAINT [PK_Meal&Food] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Member]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Member](
	[Card_id] [bigint] IDENTITY(1000,1) NOT NULL,
	[Card_name] [nvarchar](30) NOT NULL,
	[Card_bir] [date] NOT NULL,
	[Cus_height] [decimal](5, 2) NULL,
	[Cus_weight] [decimal](5, 2) NULL,
	[BFR] [decimal](5, 2) NULL,
	[Card_balance] [money] NOT NULL,
	[Card_integral] [bigint] NULL,
	[Card_pic] [nvarchar](50) NULL,
	[vip_id] [int] NOT NULL,
	[Card_begin] [date] NOT NULL,
	[Card_end] [date] NOT NULL,
	[Card_sex] [char](3) NULL,
	[Id_card] [nvarchar](20) NOT NULL,
	[Card_number] [nvarchar](20) NOT NULL,
	[Card_state] [nchar](2) NOT NULL,
	[staff_id] [int] NULL,
	[shop_id] [int] NOT NULL,
 CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED 
(
	[Card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Online]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Online](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[who] [nvarchar](30) NOT NULL,
	[state] [nchar](2) NULL,
	[endtime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Shop]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shop](
	[Shop_id] [int] IDENTITY(1,1) NOT NULL,
	[Shop_name] [nvarchar](50) NOT NULL,
	[Shop_begin] [date] NOT NULL,
	[Shop_address] [nvarchar](100) NOT NULL,
	[Shop_city] [nvarchar](20) NULL,
	[Shop_province] [nvarchar](20) NOT NULL,
	[Shop_person] [bigint] NULL,
	[Shop_money] [money] NULL,
	[Shop_number] [nvarchar](20) NOT NULL,
	[Shop_pay] [money] NOT NULL,
	[Shop_state] [nvarchar](10) NOT NULL,
	[Shop_end] [date] NULL,
	[Shop_pic] [nvarchar](100) NULL,
	[State] [nvarchar](20) NULL,
	[Shop_txt] [text] NULL,
	[Staff_id] [int] NULL,
 CONSTRAINT [PK_Shop] PRIMARY KEY CLUSTERED 
(
	[Shop_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Shop_Staff]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shop_Staff](
	[id] [int] IDENTITY(100,1) NOT NULL,
	[staff_id] [int] NULL,
	[shop_id] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Staff]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[staff_id] [int] IDENTITY(1,1) NOT NULL,
	[staff_name] [nvarchar](20) NOT NULL,
	[staff_bir] [date] NOT NULL,
	[staff_sex] [nchar](1) NOT NULL,
	[staff_city] [nvarchar](30) NOT NULL,
	[staff_address] [nvarchar](150) NOT NULL,
	[staff_idcard] [nvarchar](20) NOT NULL,
	[staff_number] [nvarchar](20) NOT NULL,
	[Department_id] [nvarchar](20) NULL,
	[shop_id] [int] NULL,
	[staff_score] [decimal](12, 2) NOT NULL,
	[staff_salary] [money] NULL,
	[staff_begin] [date] NOT NULL,
	[staff_state] [nchar](2) NULL,
	[staff_txt] [nvarchar](300) NULL,
	[staff_pic] [nvarchar](50) NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[User_id] [int] IDENTITY(1,1) NOT NULL,
	[User_admin] [nvarchar](30) NOT NULL,
	[User_pwd] [nvarchar](100) NOT NULL,
	[Shop_id] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[User_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vip]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vip](
	[vip_id] [int] IDENTITY(1,1) NOT NULL,
	[vip_name] [nvarchar](10) NOT NULL,
	[vip_discount] [decimal](3, 2) NOT NULL,
 CONSTRAINT [PK_Vip] PRIMARY KEY CLUSTERED 
(
	[vip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[v_MealFood]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_MealFood]
as
select meal_id,b.Food_name from MealFood a,Food b where a.food_id=b.Food_id
GO
/****** Object:  View [dbo].[v_taocan]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_taocan]
as
SELECT B.meal_id,LEFT(StuList,LEN(StuList)-1) as Food_name FROM (
SELECT meal_id,
(SELECT Food_name+',' FROM [dbo].[v_MealFood] 
  WHERE meal_id=A.meal_id 
  FOR XML PATH('')) AS StuList
FROM [dbo].[v_MealFood] A 
GROUP BY meal_id
) B 
GO
/****** Object:  View [dbo].[m_tdby]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[m_tdby] as
select tdby=count(*) from Member where 
datediff(day,CONVERT(varchar(30),Card_begin,23),CONVERT(varchar(30),GETDATE(),23))=2


GO
/****** Object:  View [dbo].[m_today]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[m_today] as
select today=count(*) from Member where 
datediff(day,CONVERT(varchar(30),Card_begin,23),CONVERT(varchar(30),GETDATE(),23))=0


GO
/****** Object:  View [dbo].[m_yesterday]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[m_yesterday] as
select yesterday=count(*) from Member where 
datediff(day,CONVERT(varchar(30),Card_begin,23),CONVERT(varchar(30),GETDATE(),23))=1


GO
/****** Object:  View [dbo].[staffdetail]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[staffdetail]
as
select a.staff_id,staff_name,staff_bir,staff_sex,staff_city,staff_address,staff_idcard,b.Shop_city,
staff_number,Department_name,Shop_name,staff_score,staff_salary,staff_begin,staff_state,staff_txt,
staff_pic from staff a inner join Shop b on a.shop_id=b.Shop_id
inner join Department c on a.Department_id=c.Department_id
GO
/****** Object:  View [dbo].[v_Staff]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_Staff]
as
select * from(
select ROW_NUMBER() over(order by staff_id) num,*,shop_name=(select Shop_name from Shop where shop_id=a.shop_id),
department_name=(select Department_name from Department where Department_id=a.Department_id) 
from Staff a 
where staff_name like '%%' or staff_id like '%%') a

GO
/****** Object:  View [dbo].[v_tdby]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_tdby] as
select tdby=count(*) from Consume where 
datediff(day,CONVERT(varchar(30),Cus_time,23),CONVERT(varchar(30),GETDATE(),23))=2


GO
/****** Object:  View [dbo].[v_today]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_today] as
select today=count(*) from Consume where 
datediff(day,CONVERT(varchar(30),Cus_time,23),CONVERT(varchar(30),GETDATE(),23))=0


GO
/****** Object:  View [dbo].[v_yesterday]    Script Date: 2018/7/25 11:19:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_yesterday] as
select yesterday=count(*) from Consume where 
datediff(day,CONVERT(varchar(30),Cus_time,23),CONVERT(varchar(30),GETDATE(),23))=1


GO
SET IDENTITY_INSERT [dbo].[Auto] ON 

INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (1, CAST(0x0000A8FF01369A27 AS DateTime), 1)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (2, CAST(0x0000A8FF0136A140 AS DateTime), 2)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (3, CAST(0x0000A8FF0136A2D9 AS DateTime), 1)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (6, CAST(0x0000A90200DB673E AS DateTime), 6)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (7, CAST(0x0000A90200DB699B AS DateTime), 6)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (8, CAST(0x0000A907009FA11F AS DateTime), 1)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (9, CAST(0x0000A90700DA13CF AS DateTime), 1)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (10, CAST(0x0000A90700DA3598 AS DateTime), 1)
INSERT [dbo].[Auto] ([Auto_id], [Auto_date], [Shop_id]) VALUES (13, CAST(0x0000A920009BA512 AS DateTime), 1017)
SET IDENTITY_INSERT [dbo].[Auto] OFF
SET IDENTITY_INSERT [dbo].[Chat] ON 

INSERT [dbo].[Chat] ([chat_id], [chat_name], [chat_txt], [chat_time]) VALUES (28, N'SuperAdmin', N'dadadawaw', CAST(0x0000A92700B5DC40 AS DateTime))
INSERT [dbo].[Chat] ([chat_id], [chat_name], [chat_txt], [chat_time]) VALUES (29, N'SuperAdmin', N'ssssss', CAST(0x0000A92500B5DC40 AS DateTime))
SET IDENTITY_INSERT [dbo].[Chat] OFF
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N')5bFgV$)|KT#Taa98)eH', N'测试套餐、热血鸡汤、', 223.0000, N'1', N'测试数据', CAST(0x0000A92000959D34 AS DateTime), N'会员卡', 1022, 14)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'122weqweq', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A8F400F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'1231wsww', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A8F400F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'2313ed', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A8F400F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'7z{&i_J9r6%h9w3g&V#U', N'西蓝花、测试套餐、热血鸡汤、', 238.0000, N'1', N'1234', CAST(0x0000A91F011A5EA8 AS DateTime), N'会员卡', 1044, 14)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'adawdfa', N'套餐一', 78.0000, N'1', N'无要求', CAST(0x0000A8E700000000 AS DateTime), N'会员卡', 1004, 2)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'ADC20180609', N'牛肉楠、鸡汤', 118.0000, N'1', N'随机', CAST(0x0000A8FA017286D1 AS DateTime), N'会员卡', 1012, 2)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'asdaoi23131', N'套餐一', 299.0000, N'1', N'减肥为主要目的', CAST(0x0000A8EB010573AE AS DateTime), N'会员卡', 1014, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'dad2313', N'套餐二', 199.0000, N'1', N'增脂为主要目的', CAST(0x0000A8EB01060C0F AS DateTime), N'会员卡', 1004, 2)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'dw', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A8F400F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'fghfghfghf', N'套餐三', 54.0000, N'1', N'暴饮暴食', CAST(0x0000A8E70153035D AS DateTime), N'会员卡', 1005, 2)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'hgfterte', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A8F400F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'iy1;{lPd^]KNy|x/koX%', N'暴饮暴食餐、测试套餐、', 487.0000, N'0', N'不用会员卡消费', CAST(0x0000A920009CC63A AS DateTime), N'现金', NULL, 1017)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'nishizhu1', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A91000F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'pVo5XF*HBrwFW/s^r^[=', N'测试套餐、大白菜、', 196.0000, N'1', N'没有要求', CAST(0x0000A920009C9E3D AS DateTime), N'会员卡', 1022, 1017)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'qweqwf2', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A91100F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'sfa2112', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A91200F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'weqe221', N'套餐一', 212.0000, N'1', N'随便', CAST(0x0000A91200F4694C AS DateTime), N'会员卡', 1012, 1)
INSERT [dbo].[Consume] ([Cus_id], [Cus_detail], [Cus_money], [Ifvip], [Cus_want], [Cus_time], [Cus_way], [Card_id], [shop_id]) VALUES (N'woshi123', N'套餐一', 212.0000, N'0', N'随便', CAST(0x0000A91200F4694C AS DateTime), N'现金', NULL, 1)
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A001', N'销售部', N'在外推销我们的餐厅')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A002', N'市场部', N'在市场上调研与运营')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A003', N'公关部', N'维持良好的公共关系')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A004', N'服务部', N'在餐厅内为客户提供服务')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A005', N'经理', N'高层管理')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A006', N'营养师', N'为会员用户搭配营养')
INSERT [dbo].[Department] ([Department_id], [Department_name], [Department_txt]) VALUES (N'A007', N'店长', N'创立地方商铺')
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (1, N'牛肉(进口)', 38.0000, CAST(1500.00 AS Decimal(10, 2)), N'美国洛杉矶', N'很棒', NULL, 1, N'beef.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (2, N'西蓝花', 15.0000, CAST(30.00 AS Decimal(10, 2)), N'广州', N'新鲜好吃好玩', NULL, 18, N'broccoli.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (6, N'杏仁', 15.0000, CAST(1300.00 AS Decimal(10, 2)), N'长沙', N'新鲜清脆', NULL, 14, N'almond.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (7, N'羊肉卷', 38.0000, CAST(2000.00 AS Decimal(10, 2)), N'美国', N'好吃', NULL, 15, N'roll.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (8, N'培根', 28.0000, CAST(1800.00 AS Decimal(10, 2)), N'上海', N'猪肉挺好吃', NULL, 2, N'Bacon.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (9, N'大白菜', 8.0000, CAST(300.00 AS Decimal(10, 2)), N'广西桂林', N'新鲜出品', NULL, 16, N'vegetable.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (11, N'鸡胸肉', 30.0000, CAST(2300.00 AS Decimal(10, 2)), N'湖南长沙', N'上等鸡肉', NULL, 2, N'chicken.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (12, N'圣女果', 8.0000, CAST(300.00 AS Decimal(10, 2)), N'湖南', N'红润', NULL, 18, N'fruit.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (13, N'西红柿', 13.0000, CAST(360.00 AS Decimal(10, 2)), N'广州深圳', N'新鲜', NULL, 18, N'fruit.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (14, N'热血鸡汤', 35.0000, CAST(900.00 AS Decimal(10, 2)), N'海南', N'大补之物', NULL, 4, N'chicken soap.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (15, N'山药', 30.0000, CAST(1300.00 AS Decimal(10, 2)), N'四川', N'滋养类', NULL, 3, N'Yam.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (17, N'排骨', 35.0000, CAST(2300.00 AS Decimal(10, 2)), N'德国', N'德国高山猪排骨', NULL, 2, N'null.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (21, N'苦瓜', 15.0000, CAST(800.00 AS Decimal(10, 2)), N'益阳', N'农民伯伯自种(好好吃)', NULL, 1, N'bitter.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (22, N'椰汁', 15.0000, CAST(700.00 AS Decimal(10, 2)), N'三亚', N'高产金椰子', NULL, 19, N'coconut.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (24, N'比目鱼', 28.0000, CAST(1300.00 AS Decimal(10, 2)), N'三亚', N'高蛋白质', NULL, 12, N'fish.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (25, N'榴莲', 35.0000, CAST(2000.00 AS Decimal(10, 2)), N'亚龙湾', N'水果之王', NULL, 18, N'durian.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (31, N'测试菜', 29.0000, CAST(199.00 AS Decimal(10, 2)), N'湖北武汉', N'很甜很滋润！', NULL, 19, N'coconut.jpg')
INSERT [dbo].[Food] ([Food_id], [Food_name], [Food_sale], [Food_ka], [Food_area], [Food_txt], [shop_id], [FoodType_id], [Food_pic]) VALUES (1032, N'测试菜', 18.0000, CAST(12312.00 AS Decimal(10, 2)), N'日照', N'很香', NULL, 13, N'chicken soap.jpg')
SET IDENTITY_INSERT [dbo].[Food] OFF
SET IDENTITY_INSERT [dbo].[FoodType] ON 

INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (1, N'减脂类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (2, N'增脂类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (3, N'调养类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (4, N'滋补类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (12, N'蛋白质类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (13, N'葡萄糖类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (14, N'坚果类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (15, N'增肌类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (16, N'低脂类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (17, N'低糖类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (18, N'果蔬类')
INSERT [dbo].[FoodType] ([FoodType_id], [FoodType_name]) VALUES (19, N'液体类')
SET IDENTITY_INSERT [dbo].[FoodType] OFF
SET IDENTITY_INSERT [dbo].[Meal] ON 

INSERT [dbo].[Meal] ([meal_id], [meal_name], [meal_price]) VALUES (1, N'暴饮暴食餐', 299.0000)
INSERT [dbo].[Meal] ([meal_id], [meal_name], [meal_price]) VALUES (1014, N'测试套餐', 188.0000)
SET IDENTITY_INSERT [dbo].[Meal] OFF
SET IDENTITY_INSERT [dbo].[MealFood] ON 

INSERT [dbo].[MealFood] ([id], [food_id], [meal_id]) VALUES (3, 1, 1)
INSERT [dbo].[MealFood] ([id], [food_id], [meal_id]) VALUES (4, 2, 1)
INSERT [dbo].[MealFood] ([id], [food_id], [meal_id]) VALUES (7, 6, 1)
INSERT [dbo].[MealFood] ([id], [food_id], [meal_id]) VALUES (1048, 1032, 1014)
INSERT [dbo].[MealFood] ([id], [food_id], [meal_id]) VALUES (1049, 6, 1014)
SET IDENTITY_INSERT [dbo].[MealFood] OFF
SET IDENTITY_INSERT [dbo].[Member] ON 

INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1022, N'肖华', CAST(0x95230B00 AS Date), CAST(178.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 803.0000, 12, N'1.jpg', 5, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'正常', 6, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1025, N'周子雄', CAST(0x28220B00 AS Date), CAST(183.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'2.jpg', 2, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'正常', 4, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1027, N'刘瑞欣', CAST(0x03250B00 AS Date), CAST(180.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'3.jpg', 1, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'女 ', N'43092938475465743', N'13455675677', N'正常', 6, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1028, N'席月林', CAST(0x28220B00 AS Date), CAST(182.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'null.jpg', 2, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'正常', 4, 4)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1029, N'潘卓安', CAST(0xBB200B00 AS Date), CAST(181.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 3, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'女 ', N'43092938475465743', N'13455675677', N'冻结', 6, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1030, N'李超凡', CAST(0x70260B00 AS Date), CAST(176.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 4, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'冻结', 4, 4)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1031, N'宋龙', CAST(0x95230B00 AS Date), CAST(173.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 2, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'冻结', 6, 4)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1032, N'龙思洋', CAST(0x95230B00 AS Date), CAST(178.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 3, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'女 ', N'43092938475465743', N'13455675677', N'冻结', 4, 5)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1034, N'黄宁', CAST(0xBB200B00 AS Date), CAST(178.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 2, CAST(0x603E0B00 AS Date), CAST(0xA8420B00 AS Date), N'男 ', N'43092938475465743', N'13455675677', N'冻结', 4, 4)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1035, N'周方舟', CAST(0x95230B00 AS Date), CAST(178.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 1, CAST(0x6B3E0B00 AS Date), CAST(0xA8420B00 AS Date), N'女 ', N'43092938475465743', N'13455675677', N'冻结', 6, 6)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1037, N'刘威', CAST(0x95230B00 AS Date), CAST(178.00 AS Decimal(5, 2)), CAST(69.00 AS Decimal(5, 2)), CAST(12.00 AS Decimal(5, 2)), 1222.0000, 22, N'xh.jpg', 3, CAST(0x6C3E0B00 AS Date), CAST(0xA8420B00 AS Date), N'女 ', N'43092938475465743', N'13455675677', N'冻结', 6, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1038, N'我是一头猪', CAST(0xEC3E0B00 AS Date), CAST(123.00 AS Decimal(5, 2)), CAST(122.00 AS Decimal(5, 2)), CAST(22.00 AS Decimal(5, 2)), 11000.0000, 0, N'3.jpg', 4, CAST(0x6C3E0B00 AS Date), CAST(0xA9420B00 AS Date), N'男 ', N'333333333333333333', N'13549612188', N'正常', NULL, 1)
INSERT [dbo].[Member] ([Card_id], [Card_name], [Card_bir], [Cus_height], [Cus_weight], [BFR], [Card_balance], [Card_integral], [Card_pic], [vip_id], [Card_begin], [Card_end], [Card_sex], [Id_card], [Card_number], [Card_state], [staff_id], [shop_id]) VALUES (1039, N'我曹你吗', CAST(0x4C3E0B00 AS Date), CAST(123.00 AS Decimal(5, 2)), CAST(212.00 AS Decimal(5, 2)), CAST(223.00 AS Decimal(5, 2)), 2000.0000, 0, N'3.jpg', 5, CAST(0x6D3E0B00 AS Date), CAST(0xA9420B00 AS Date), N'男 ', N'4309032133939219', N'13549612188', N'正常', 6, 1)
SET IDENTITY_INSERT [dbo].[Member] OFF
SET IDENTITY_INSERT [dbo].[Online] ON 

INSERT [dbo].[Online] ([id], [who], [state], [endtime]) VALUES (1, N'SuperAdmin', N'离线', CAST(0x0000A92800B660AC AS DateTime))
INSERT [dbo].[Online] ([id], [who], [state], [endtime]) VALUES (2, N'Admin', N'离线', CAST(0x0000A9260098001C AS DateTime))
INSERT [dbo].[Online] ([id], [who], [state], [endtime]) VALUES (3, N'Takin', N'离线', CAST(0x0000A92500D6C4DC AS DateTime))
INSERT [dbo].[Online] ([id], [who], [state], [endtime]) VALUES (4, N'Test', N'离线', CAST(0x0000A92500D6C4DC AS DateTime))
SET IDENTITY_INSERT [dbo].[Online] OFF
SET IDENTITY_INSERT [dbo].[Shop] ON 

INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (1, N'长沙芙蓉区店', CAST(0xE03D0B00 AS Date), N'芙蓉区五一广场悦方ID MALL3楼', N'长沙', N'湖南', 3000, 123000.0000, N'ABC1234', 20000.0000, N'已缴费', NULL, N'changsha2.jpg', N'运营中', N'长沙芙蓉区首家餐馆，由著名健康管理师肖华创立而成，改餐馆处于五一广场繁华地段，是中国首家Flower健康餐馆，请大家多多关照', 3)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (2, N'长沙天心区店', CAST(0x673C0B00 AS Date), N'德思勤广场', N'长沙', N'湖南', 100, 412330.0000, N'ASD2131', 13000.0000, N'未缴费', NULL, N'changsha.jpg', N'运营中', N'暂无', 13)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (4, N'上海陆家嘴', CAST(0x233B0B00 AS Date), N'陆家嘴滨江广场', N'上海', N'上海', 150, 3244444.0000, N'DAS2323', 30000.0000, N'已缴费', NULL, N'shang1.jpg,shang2.jpg,shang3.jpg', N'运营中', N'暂无', 5)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (5, N'北京中关村', CAST(0x593E0B00 AS Date), N'北京中关村3组1209室', N'北京', N'北京', 0, 0.0000, N'ABSD231', 35000.0000, N'已缴费', NULL, N'shang1.jpg', N'运营中', N'北京首家健康体系餐厅', 4)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (6, N'长沙德思勤店', CAST(0x593E0B00 AS Date), N'德思勤广场', N'长沙', N'湖南', 0, 0.0000, N'asd231', 15000.0000, N'已缴费', NULL, N'changsha.jpg,changsha2.jpg', N'运营中', N'新创', 9)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (7, N'北京朝阳顶级店', CAST(0x613E0B00 AS Date), N'在你心里', N'北京', N'北京', 0, 0.0000, N'asd231', 20000.0000, N'已缴费', NULL, N'null.jpg', N'运营中', N'滚你吗墩子', 10)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (11, N'无敌小店王', CAST(0xED3E0B00 AS Date), N'不告诉你', N'北京', N'北京', 0, 0.0000, N'201862196GNEV', 2333.0000, N'已缴费', NULL, N'null.jpg', N'运营中', N'嘻嘻嘻嘻嘻', 9)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (12, N'我是大笨蛋', CAST(0x623E0B00 AS Date), N'哈尔滨的齐齐哈尔', N'哈尔滨', N'黑龙江', 0, 0.0000, N'2018622322BRQK', 23333.0000, N'已缴费', NULL, N'/beef.jpg', N'运营中', N'好冷的', 13)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (14, N'这是一条测试店铺', CAST(0x7A3E0B00 AS Date), N'齐齐哈尔大学', N'齐齐哈尔', N'黑龙江', 0, 0.0000, N'2018716280FZYO', 120000.0000, N'已缴费', NULL, N'null.jpg', N'运营中', N'很屌的一个店铺！', 18)
INSERT [dbo].[Shop] ([Shop_id], [Shop_name], [Shop_begin], [Shop_address], [Shop_city], [Shop_province], [Shop_person], [Shop_money], [Shop_number], [Shop_pay], [Shop_state], [Shop_end], [Shop_pic], [State], [Shop_txt], [Staff_id]) VALUES (1017, N'测试店铺', CAST(0x7B3E0B00 AS Date), N'日照大学', N'日照', N'山东', 0, 0.0000, N'2018717114GWJK', 25000.0000, N'已缴费', NULL, N'changsha.jpg,changsha2.jpg', N'运营中', N'很棒', 1018)
SET IDENTITY_INSERT [dbo].[Shop] OFF
SET IDENTITY_INSERT [dbo].[Shop_Staff] ON 

INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (100, 1, 1)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (101, 2, 4)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (102, 3, 1)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (103, 4, 5)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (104, 5, 4)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (105, 6, 1)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (106, 7, 1)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (107, 9, 6)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (108, 10, 7)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (109, 13, 2)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (110, 13, 12)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (111, 9, 11)
INSERT [dbo].[Shop_Staff] ([id], [staff_id], [shop_id]) VALUES (115, 18, 14)
SET IDENTITY_INSERT [dbo].[Shop_Staff] OFF
SET IDENTITY_INSERT [dbo].[Staff] ON 

INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (1, N'刘德华', CAST(0x62060B00 AS Date), N'男', N'北京        ', N'北京胡同里', N'43090319970425001X', N'17780418232', N'A001', 1, CAST(100.00 AS Decimal(12, 2)), 4000.0000, CAST(0x74210B00 AS Date), N'休假', N'加油', N'wu.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (2, N'张学友', CAST(0x68220B00 AS Date), N'女', N'长沙', N'长沙芙蓉大厦', N'432421198022260506', N'18956213546', N'A002', 4, CAST(0.00 AS Decimal(12, 2)), 6000.0000, CAST(0x3C3E0B00 AS Date), N'在职', N'努力', N'wu.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (3, N'肖华', CAST(0x74210B00 AS Date), N'男', N'长沙', N'长沙万达公馆', N'43090319950201115X', N'18954662131', N'A007', 1, CAST(8888.00 AS Decimal(12, 2)), 500000.0000, CAST(0x042A0B00 AS Date), N'在职', N'我自信，我能行！', N'wu.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (4, N'周子雄', CAST(0x74210B00 AS Date), N'男', N'长沙', N'长沙万达公馆', N'43090319950201115X', N'18954662131', N'A007', 4, CAST(1111.00 AS Decimal(12, 2)), 500000.0000, CAST(0x042A0B00 AS Date), N'在职', N'成就自己', N'2.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (5, N'宋龙', CAST(0xCD210B00 AS Date), N'男', N'长沙', N'江山如画公馆', N'1231241241241411', N'1873847585', N'A007', 4, CAST(2222.00 AS Decimal(12, 2)), 231313.0000, CAST(0x6A210B00 AS Date), N'休假', N'我一定能成功', N'3.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (6, N'王子怡', CAST(0x74210B00 AS Date), N'女', N'长沙', N'江山如画公馆', N'1231231241', N'123123123', N'A006', 1, CAST(22332.00 AS Decimal(12, 2)), 321312.0000, CAST(0x07250B00 AS Date), N'在职', N'我一定失败', N'4.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (7, N'安妮', CAST(0x74210B00 AS Date), N'女', N'长沙', N'江山如画公馆', N'1231231241', N'123123123', N'A006', 1, CAST(22332.00 AS Decimal(12, 2)), 321312.0000, CAST(0x07250B00 AS Date), N'在职', N'我一定失败', N'4.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (9, N'无敌大王', CAST(0xFC210B00 AS Date), N'女', N'上海', N'上海陆家嘴冰江一号', N'43202910392012', N'17392893291', N'A007', 6, CAST(0.00 AS Decimal(12, 2)), 2000.0000, CAST(0x613E0B00 AS Date), N'在职', N'加油努力我能行', N'wu.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (10, N'周积极', CAST(0xA4210B00 AS Date), N'女', N'长沙', N'中山亭', N'430901302192101231', N'13423213123', N'A007', 1, CAST(0.00 AS Decimal(12, 2)), 2000.0000, CAST(0x613E0B00 AS Date), N'在职', N'第一次做', N'2.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (13, N'nmsl', CAST(0x407A0900 AS Date), N'男', N'日照', N'不告诉你', N'12313123123', N'12312312312', N'A007', 2, CAST(0.00 AS Decimal(12, 2)), 20000.0000, CAST(0x613E0B00 AS Date), N'在职', N'12312312321', N'3.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (14, N'flower', CAST(0x683E0B00 AS Date), N'男', N'长沙', N'123123123', N'123124124123124', N'123412412', N'A004', 2, CAST(0.00 AS Decimal(12, 2)), 123213.0000, CAST(0x683E0B00 AS Date), N'在职', N'12312312312312', N'3.JPG')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (18, N'这是一条测试店主', CAST(0x381C0B00 AS Date), N'男', N'齐齐哈尔', N'齐齐哈尔大学', N'43090319980313001X', N'17680318313', N'A007', NULL, CAST(0.00 AS Decimal(12, 2)), 23000.0000, CAST(0x7A3E0B00 AS Date), N'在职', N'很可爱的一个店主', N'2.jpg')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (19, N'这是一条测试员工', CAST(0x7A3E0B00 AS Date), N'男', N'湖北', N'湖北武汉市武汉大学', N'430903199803232131', N'12341213123', N'A006', 14, CAST(0.00 AS Decimal(12, 2)), 10000.0000, CAST(0x7A3E0B00 AS Date), N'在职', N'这是第一位来的员工！很开心', N'3.JPG')
INSERT [dbo].[Staff] ([staff_id], [staff_name], [staff_bir], [staff_sex], [staff_city], [staff_address], [staff_idcard], [staff_number], [Department_id], [shop_id], [staff_score], [staff_salary], [staff_begin], [staff_state], [staff_txt], [staff_pic]) VALUES (1018, N'测试店主', CAST(0x1C310B00 AS Date), N'男', N'日照', N'山东', N'430901023123123123', N'12312312312', N'A007', NULL, CAST(0.00 AS Decimal(12, 2)), 2222.0000, CAST(0x7B3E0B00 AS Date), N'在职', N'弄不好', N'2.jpg')
SET IDENTITY_INSERT [dbo].[Staff] OFF
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([User_id], [User_admin], [User_pwd], [Shop_id]) VALUES (1, N'Admin', N'e10adc3949ba59abbe56e057f20f883e', 1)
INSERT [dbo].[User] ([User_id], [User_admin], [User_pwd], [Shop_id]) VALUES (3, N'SuperAdmin', N'21232f297a57a5a743894a0e4a801fc3', NULL)
INSERT [dbo].[User] ([User_id], [User_admin], [User_pwd], [Shop_id]) VALUES (8, N'Takin', N'8a3cde3d011fc0fb3f3973b9e1cde101', 6)
INSERT [dbo].[User] ([User_id], [User_admin], [User_pwd], [Shop_id]) VALUES (1012, N'Test', N'81dc9bdb52d04dc20036dbd8313ed055', 1017)
SET IDENTITY_INSERT [dbo].[User] OFF
SET IDENTITY_INSERT [dbo].[Vip] ON 

INSERT [dbo].[Vip] ([vip_id], [vip_name], [vip_discount]) VALUES (1, N'月卡', CAST(0.98 AS Decimal(3, 2)))
INSERT [dbo].[Vip] ([vip_id], [vip_name], [vip_discount]) VALUES (2, N'季卡', CAST(0.90 AS Decimal(3, 2)))
INSERT [dbo].[Vip] ([vip_id], [vip_name], [vip_discount]) VALUES (3, N'年卡', CAST(0.85 AS Decimal(3, 2)))
INSERT [dbo].[Vip] ([vip_id], [vip_name], [vip_discount]) VALUES (4, N'金卡', CAST(0.70 AS Decimal(3, 2)))
INSERT [dbo].[Vip] ([vip_id], [vip_name], [vip_discount]) VALUES (5, N'钻石卡', CAST(0.65 AS Decimal(3, 2)))
SET IDENTITY_INSERT [dbo].[Vip] OFF
ALTER TABLE [dbo].[Auto] ADD  CONSTRAINT [DF_Auto_Auto_date]  DEFAULT (getdate()) FOR [Auto_date]
GO
ALTER TABLE [dbo].[Consume] ADD  CONSTRAINT [DF_Consume_Cus_time]  DEFAULT (getdate()) FOR [Cus_time]
GO
ALTER TABLE [dbo].[Food] ADD  CONSTRAINT [DF__Food__Food_pic__440B1D61]  DEFAULT ('null') FOR [Food_pic]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_Card_balance]  DEFAULT ((0)) FOR [Card_balance]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_Card_integral]  DEFAULT ((0)) FOR [Card_integral]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_Card_pic]  DEFAULT ('null') FOR [Card_pic]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_Card_begin]  DEFAULT (getdate()) FOR [Card_begin]
GO
ALTER TABLE [dbo].[Shop] ADD  CONSTRAINT [DF_Shop_Shop_city]  DEFAULT (N'null.jpg') FOR [Shop_city]
GO
ALTER TABLE [dbo].[Shop] ADD  CONSTRAINT [DF_Shop_Shop_person]  DEFAULT ((0)) FOR [Shop_person]
GO
ALTER TABLE [dbo].[Shop] ADD  CONSTRAINT [DF_Shop_Shop_money]  DEFAULT ((0)) FOR [Shop_money]
GO
ALTER TABLE [dbo].[Shop] ADD  CONSTRAINT [DF_Shop_Shop_pic]  DEFAULT (N'null.jpg') FOR [Shop_pic]
GO
ALTER TABLE [dbo].[Shop] ADD  CONSTRAINT [DF_Shop_State]  DEFAULT (N'运营中') FOR [State]
GO
ALTER TABLE [dbo].[Staff] ADD  CONSTRAINT [DF_Staff_staff_score]  DEFAULT ((0)) FOR [staff_score]
GO
ALTER TABLE [dbo].[Staff] ADD  CONSTRAINT [DF_Staff_staff_txt]  DEFAULT (N'无') FOR [staff_txt]
GO
ALTER TABLE [dbo].[Staff] ADD  CONSTRAINT [DF_Staff_staff_pic]  DEFAULT ('wu.jpg') FOR [staff_pic]
GO
ALTER TABLE [dbo].[Auto]  WITH CHECK ADD  CONSTRAINT [FK_Auto_Shop] FOREIGN KEY([Shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[Auto] CHECK CONSTRAINT [FK_Auto_Shop]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [FK_Food_FoodType] FOREIGN KEY([FoodType_id])
REFERENCES [dbo].[FoodType] ([FoodType_id])
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [FK_Food_FoodType]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [FK_Food_Shop] FOREIGN KEY([shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [FK_Food_Shop]
GO
ALTER TABLE [dbo].[Forget]  WITH CHECK ADD  CONSTRAINT [FK_Forget_Shop] FOREIGN KEY([shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[Forget] CHECK CONSTRAINT [FK_Forget_Shop]
GO
ALTER TABLE [dbo].[MealFood]  WITH CHECK ADD  CONSTRAINT [FK_Meal&Food_Food] FOREIGN KEY([food_id])
REFERENCES [dbo].[Food] ([Food_id])
GO
ALTER TABLE [dbo].[MealFood] CHECK CONSTRAINT [FK_Meal&Food_Food]
GO
ALTER TABLE [dbo].[Member]  WITH CHECK ADD  CONSTRAINT [FK_Member_Shop] FOREIGN KEY([shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[Member] CHECK CONSTRAINT [FK_Member_Shop]
GO
ALTER TABLE [dbo].[Member]  WITH CHECK ADD  CONSTRAINT [FK_Member_Staff] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([staff_id])
GO
ALTER TABLE [dbo].[Member] CHECK CONSTRAINT [FK_Member_Staff]
GO
ALTER TABLE [dbo].[Member]  WITH CHECK ADD  CONSTRAINT [FK_Member_Vip] FOREIGN KEY([vip_id])
REFERENCES [dbo].[Vip] ([vip_id])
GO
ALTER TABLE [dbo].[Member] CHECK CONSTRAINT [FK_Member_Vip]
GO
ALTER TABLE [dbo].[Shop_Staff]  WITH CHECK ADD  CONSTRAINT [FK_Shop_Staff_Staff] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([staff_id])
GO
ALTER TABLE [dbo].[Shop_Staff] CHECK CONSTRAINT [FK_Shop_Staff_Staff]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Department] FOREIGN KEY([Department_id])
REFERENCES [dbo].[Department] ([Department_id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Department]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Shop] FOREIGN KEY([Department_id])
REFERENCES [dbo].[Department] ([Department_id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Shop]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Shop1] FOREIGN KEY([shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Staff_Shop1]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Shop] FOREIGN KEY([Shop_id])
REFERENCES [dbo].[Shop] ([Shop_id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Shop]
GO
USE [master]
GO
ALTER DATABASE [FlowerNutrition] SET  READ_WRITE 
GO
