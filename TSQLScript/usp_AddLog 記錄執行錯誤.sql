IF OBJECT_ID('dbo.usp_AddLog') IS NOT NULL 
	DROP PROCEDURE [dbo].[usp_AddLog]
GO

	CREATE PROCEDURE [dbo].[usp_AddLog]
	(
		@_InBox_ReadID					tinyint					,		-- ���� Log �ɬO�ϥβĴX��
		@_InBox_SPNAME					nvarchar(120)		,		-- ���檺�w�s�{�ǦW��
		@_InBox_GroupID					uniqueidentifier	,		-- ����s�եN�X
		@_InBox_ExProgram				nvarchar(40)			,		-- ���檺�ʧ@�O����
		@_InBox_ActionJSON			nvarchar(Max)		,		-- ���檺�L�{�O����
		@_OutBox_ReturnValues		nvarchar(Max)		output -- �^�ǰ��檺����
	) 
	AS
	
	-- ========================= �s�W�P���@�`�N�ƶ�(������u�W�w) =====================
	-- �����`�ѻ����мg�b�o�̡A�H�K�q Visual Studio ��� SQL �������e�S���@�_�W�h
	-- �p�G�n�ק�ХH�o�ɮ׬��D�A�åH SSMS 19.0 ���H�W�ӭק�H�K�����㪺�s��Ҧ�
	-- �s��ɽХ�ѡu�M�פH���v�Ӷi��������ץ��A�ק�e�]�нT�w�b C# Class ���A
	-- �����ǵ{�Ǧ��e�Ѧҡf��æA�[�H�T�w�ק�ᤣ�|������v�T�A�A��ץ��H�U TSQL ���y�k�A�H�K
	-- �A�ק��A�|�ϱo��L�{�Ǥ]���ޥΨ�H�U����ƦӦ��Ҽv�T�C
	-- ==========================================================================
	-- ���w�ɮס@�Gusp_AddLog �O�����檺�ʧ@.sql
	-- �M�׶��ء@�G
	-- �M�ץγ~�@�G�O�� sp ���檺�ʧ@����
	-- �M�׸�Ʈw�G
	-- �M�׸�ƪ�G
	-- �M�פH���@�G
	-- �M�פ���@�G
	-- �M�׻����@�G@_InBox_ReadID				�̥D�n�O���Ӱ��O�������ϥΡA�]�� Log �O������|�H���P�����e�άO���檺�{�Ǥ��@�w�|�����P���O�����e
	-- �@�@�@�@�@�G@_InBox_ActionJSON		�O�O�����檺���ػP���e�H�Q�������X�R���O�d
	-- �@�@�@�@�@�G@_InBox_GroupID				�̥D�n�b����L�{�|���@��q���L�{�A�i�H�z�L�o GUID �i�H�F�Ѩ��Ӱ���L�{�A���M��L���ؤ]�O����
	--																			�������D����쨺�@�Ӷ��ؤF??
	-- =========================================================================

	--======= �ŧi�w�]���ܼ�	================
	DECLARE @_StoredProgramsNAME nvarchar(100) = 'usp_AddLog' -- ���涵��
	
	--======= �ŧi�n�x�s�����	================
	DECLARE @_ReturnTable Table 
	(
		[RT_Status]					bit							,		--���浲�G
		[RT_ActionValues]		nvarchar(2000)			--�^�ǵ��G����
	) 
	
	--======= ����欰�P�ʧ@	================
	-- @_InBox_ServiceID				=	0
	-- ��°O���@�����椺�e
	--=====================================

	if(@_InBox_ReadID = 0) 
		Begin

		INSERT INTO MyOffice_ExcuteionLog 
		(
			DeLog_StoredPrograms,
			DeLog_GroupID,
			DeLog_ExecutionProgram,
			DeLog_ExecutionInfo
		)
		Values
		(
			@_InBox_SPNAME,
			@_InBox_GroupID,
			@_InBox_ExProgram,
			@_InBox_ActionJSON
		)

		SET	@_OutBox_ReturnValues =
		(
				SELECT
						Top 100 
						DeLog_AutoID											AS 'AutoID',
						DeLog_ExecutionProgram					AS 'NAME',
						DeLog_ExecutionInfo							AS 'Action',
						DeLog_ExDateTime								AS 'DateTime'
				FROM
						MyOffice_ExcuteionLog						WITH(NOLOCK)
				WHERE
					DeLog_GroupID = @_InBox_GroupID
		
				ORDER BY
					DeLog_AutoID FOR json PATH,
					ROOT('ProgramLog'),
					INCLUDE_NULL_VALUES
		) 
	
		RETURN

End