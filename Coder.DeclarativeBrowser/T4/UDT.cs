/*******************************************************************************************************
 *	THIS IS AN AUTO-GENERATED FILE.  
 *  DO NOT ALTER OR YOUR CHANGES WILL BE LOST.
 *******************************************************************************************************/

using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.CodeDom.Compiler;
using Medidata.Dapper;

namespace Coder.DeclarativeBrowser.Db {

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ActionGroups_T
    {
        public Int32 ActionGroupId { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String OID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ActionGroups_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ActionGroups_TEnumerableExtension()
        {
            _DataTable = new DataTable("ActionGroups_T");

            _DataTable.Columns.Add(new DataColumn("ActionGroupId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("OID", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<ActionGroups_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ActionGroups_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ActionGroups_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ActionGroupId"] = item.ActionGroupId;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["OID"] = item.OID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ActionGroupsOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ActionGroupsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ActionGroupsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ActionGroupsOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ActionGroupsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ActionGroupsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ActionGroupsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ActionTypes_T
    {
        public Int32 ActionType { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String Name { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ActionTypes_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ActionTypes_TEnumerableExtension()
        {
            _DataTable = new DataTable("ActionTypes_T");

            _DataTable.Columns.Add(new DataColumn("ActionType", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Name", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<ActionTypes_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ActionTypes_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ActionTypes_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ActionType"] = item.ActionType;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["Name"] = item.Name;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ActionTypesOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ActionTypesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ActionTypesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ActionTypesOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ActionTypesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ActionTypesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ActionTypesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Activations_T
    {
        public DateTime Activated { get; set; }
        public String ActivationCode { get; set; }
        public Int32 ActivationID { get; set; }
        public Int32 ActivationStatus { get; set; }
        public Boolean AlertSent { get; set; }
        public Int32 Attempts { get; set; }
        public Boolean Completed { get; set; }
        public DateTime Created { get; set; }
        public Int32 CreatedByUserID { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public DateTime LastAttempt { get; set; }
        public Int32 SegmentID { get; set; }
        public Int32 UserID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Activations_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Activations_TEnumerableExtension()
        {
            _DataTable = new DataTable("Activations_T");

            _DataTable.Columns.Add(new DataColumn("Activated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("ActivationCode", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ActivationID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ActivationStatus", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AlertSent", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Attempts", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Completed", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CreatedByUserID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("LastAttempt", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<Activations_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Activations_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Activations_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Activated"] = item.Activated;
            row["ActivationCode"] = item.ActivationCode;
            row["ActivationID"] = item.ActivationID;
            row["ActivationStatus"] = item.ActivationStatus;
            row["AlertSent"] = item.AlertSent;
            row["Attempts"] = item.Attempts;
            row["Completed"] = item.Completed;
            row["Created"] = item.Created;
            row["CreatedByUserID"] = item.CreatedByUserID;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["LastAttempt"] = item.LastAttempt;
            row["SegmentID"] = item.SegmentID;
            row["UserID"] = item.UserID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ActivationsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ActivationsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ActivationsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ActivationsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ActivationsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ActivationsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ActivationsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditDetailTypes_T
    {
        public String AdditionalTrackingProperties { get; set; }
        public Int32 AuditDetailTypeId { get; set; }
        public Int32 AuditTypeId { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ObjectTypeId { get; set; }
        public String PropertyName { get; set; }
        public String TranslationStringName { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditDetailTypes_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditDetailTypes_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditDetailTypes_T");

            _DataTable.Columns.Add(new DataColumn("AdditionalTrackingProperties", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("AuditDetailTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuditTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("PropertyName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("TranslationStringName", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditDetailTypes_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditDetailTypes_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditDetailTypes_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["AdditionalTrackingProperties"] = item.AdditionalTrackingProperties;
            row["AuditDetailTypeId"] = item.AuditDetailTypeId;
            row["AuditTypeId"] = item.AuditTypeId;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ObjectTypeId"] = item.ObjectTypeId;
            row["PropertyName"] = item.PropertyName;
            row["TranslationStringName"] = item.TranslationStringName;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditDetailTypesOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditDetailTypesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditDetailTypesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditDetailTypesOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditDetailTypesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditDetailTypesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditDetailTypesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditProcesss_T
    {
        public String AuditProcess { get; set; }
        public Int32 AuditProcessId { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Boolean IsDefault { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditProcesss_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditProcesss_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditProcesss_T");

            _DataTable.Columns.Add(new DataColumn("AuditProcess", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("AuditProcessId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsDefault", typeof(Boolean)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditProcesss_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditProcesss_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditProcesss_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["AuditProcess"] = item.AuditProcess;
            row["AuditProcessId"] = item.AuditProcessId;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["IsDefault"] = item.IsDefault;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditProcesssOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditProcesssOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditProcesssOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditProcesssOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditProcesssOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditProcesssOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditProcesssOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Audits_T
    {
        public Int32 AuditDetailTypeId { get; set; }
        public Int64 AuditedObjectId { get; set; }
        public Int64 AuditedObjectTypeId { get; set; }
        public Int64 AuditId { get; set; }
        public Int64 AuditRefernaceObjectId { get; set; }
        public Int32 AuditRefernaceObjectTypeId { get; set; }
        public Int64 AuditSourceId { get; set; }
        public DateTime AuditTime { get; set; }
        public Int32 AuditUserId { get; set; }
        public String BeforeData { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String Detail1 { get; set; }
        public String Detail2 { get; set; }
        public String Detail3 { get; set; }
        public String Detail4 { get; set; }
        public String Detail5 { get; set; }
        public String ManualText { get; set; }
        public String NewData { get; set; }
        public String PropertyName { get; set; }
        public Int32 SegmentID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Audits_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Audits_TEnumerableExtension()
        {
            _DataTable = new DataTable("Audits_T");

            _DataTable.Columns.Add(new DataColumn("AuditDetailTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuditedObjectId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditedObjectTypeId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditRefernaceObjectId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditRefernaceObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuditSourceId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditTime", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("AuditUserId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("BeforeData", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Detail1", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Detail2", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Detail3", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Detail4", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Detail5", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ManualText", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("NewData", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("PropertyName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<Audits_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Audits_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Audits_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["AuditDetailTypeId"] = item.AuditDetailTypeId;
            row["AuditedObjectId"] = item.AuditedObjectId;
            row["AuditedObjectTypeId"] = item.AuditedObjectTypeId;
            row["AuditId"] = item.AuditId;
            row["AuditRefernaceObjectId"] = item.AuditRefernaceObjectId;
            row["AuditRefernaceObjectTypeId"] = item.AuditRefernaceObjectTypeId;
            row["AuditSourceId"] = item.AuditSourceId;
            row["AuditTime"] = item.AuditTime;
            row["AuditUserId"] = item.AuditUserId;
            row["BeforeData"] = item.BeforeData;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["Detail1"] = item.Detail1;
            row["Detail2"] = item.Detail2;
            row["Detail3"] = item.Detail3;
            row["Detail4"] = item.Detail4;
            row["Detail5"] = item.Detail5;
            row["ManualText"] = item.ManualText;
            row["NewData"] = item.NewData;
            row["PropertyName"] = item.PropertyName;
            row["SegmentID"] = item.SegmentID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditSources_T
    {
        public Int64 AuditedObjectId { get; set; }
        public Int32 AuditedObjectTypeId { get; set; }
        public Int32 AuditProcessId { get; set; }
        public String AuditReasonNote { get; set; }
        public Int64 AuditSourceId { get; set; }
        public DateTime AuditSourceTime { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String Host { get; set; }
        public Int32 InteractionId { get; set; }
        public String Process { get; set; }
        public String Product { get; set; }
        public Int32 SegmentID { get; set; }
        public String ThreadName { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditSources_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditSources_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditSources_T");

            _DataTable.Columns.Add(new DataColumn("AuditedObjectId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditedObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuditProcessId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuditReasonNote", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("AuditSourceId", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("AuditSourceTime", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Host", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("InteractionId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Process", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Product", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ThreadName", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditSources_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditSources_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditSources_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["AuditedObjectId"] = item.AuditedObjectId;
            row["AuditedObjectTypeId"] = item.AuditedObjectTypeId;
            row["AuditProcessId"] = item.AuditProcessId;
            row["AuditReasonNote"] = item.AuditReasonNote;
            row["AuditSourceId"] = item.AuditSourceId;
            row["AuditSourceTime"] = item.AuditSourceTime;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["Host"] = item.Host;
            row["InteractionId"] = item.InteractionId;
            row["Process"] = item.Process;
            row["Product"] = item.Product;
            row["SegmentID"] = item.SegmentID;
            row["ThreadName"] = item.ThreadName;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditSourcesOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditSourcesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditSourcesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditSourcesOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditSourcesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditSourcesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditSourcesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class AuditsOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class AuditsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static AuditsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("AuditsOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<AuditsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("AuditsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(AuditsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class BasicTermComponent_UDT
    {
        public Int32 KeyId { get; set; }
        public Int32 StringId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class BasicTermComponent_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static BasicTermComponent_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("BasicTermComponent_UDT");

            _DataTable.Columns.Add(new DataColumn("KeyId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("StringId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<BasicTermComponent_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("BasicTermComponent_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(BasicTermComponent_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["KeyId"] = item.KeyId;
            row["StringId"] = item.StringId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Configurations_T
    {
        public String ConfigValue { get; set; }
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ID { get; set; }
        public Int32 SegmentID { get; set; }
        public Int32 StudyID { get; set; }
        public String Tag { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Configurations_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Configurations_TEnumerableExtension()
        {
            _DataTable = new DataTable("Configurations_T");

            _DataTable.Columns.Add(new DataColumn("ConfigValue", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("StudyID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Tag", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<Configurations_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Configurations_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Configurations_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ConfigValue"] = item.ConfigValue;
            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ID"] = item.ID;
            row["SegmentID"] = item.SegmentID;
            row["StudyID"] = item.StudyID;
            row["Tag"] = item.Tag;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ConfigurationsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ConfigurationsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ConfigurationsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ConfigurationsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<ConfigurationsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ConfigurationsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ConfigurationsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ID_UDT
    {
        public Int32 Id { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ID_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ID_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("ID_UDT");

            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ID_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ID_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ID_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Id"] = item.Id;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ImpliedActionTypes_T
    {
        public Int32 ActionType { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ImpliedActionType { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ImpliedActionTypes_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ImpliedActionTypes_TEnumerableExtension()
        {
            _DataTable = new DataTable("ImpliedActionTypes_T");

            _DataTable.Columns.Add(new DataColumn("ActionType", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ImpliedActionType", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ImpliedActionTypes_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ImpliedActionTypes_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ImpliedActionTypes_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ActionType"] = item.ActionType;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ImpliedActionType"] = item.ImpliedActionType;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ImpliedActionTypesOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ImpliedActionTypesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ImpliedActionTypesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ImpliedActionTypesOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ImpliedActionTypesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ImpliedActionTypesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ImpliedActionTypesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Interactions_T
    {
        public Int32 ClickCount { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String EncryptionKey { get; set; }
        public DateTime Finish { get; set; }
        public Int32 InteractionID { get; set; }
        public Int32 InteractionStatus { get; set; }
        public DateTime LastAccess { get; set; }
        public String LastAttemptedURL { get; set; }
        public String NetWorkAddress { get; set; }
        public String SessionID { get; set; }
        public DateTime Start { get; set; }
        public Int32 UserID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Interactions_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Interactions_TEnumerableExtension()
        {
            _DataTable = new DataTable("Interactions_T");

            _DataTable.Columns.Add(new DataColumn("ClickCount", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("EncryptionKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Finish", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("InteractionID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("InteractionStatus", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("LastAccess", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("LastAttemptedURL", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("NetWorkAddress", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SessionID", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Start", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<Interactions_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Interactions_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Interactions_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ClickCount"] = item.ClickCount;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["EncryptionKey"] = item.EncryptionKey;
            row["Finish"] = item.Finish;
            row["InteractionID"] = item.InteractionID;
            row["InteractionStatus"] = item.InteractionStatus;
            row["LastAccess"] = item.LastAccess;
            row["LastAttemptedURL"] = item.LastAttemptedURL;
            row["NetWorkAddress"] = item.NetWorkAddress;
            row["SessionID"] = item.SessionID;
            row["Start"] = item.Start;
            row["UserID"] = item.UserID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class InteractionsOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class InteractionsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static InteractionsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("InteractionsOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<InteractionsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("InteractionsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(InteractionsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class LevelIds_UDT
    {
        public Int32 Id { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class LevelIds_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static LevelIds_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("LevelIds_UDT");

            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<LevelIds_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("LevelIds_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(LevelIds_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Id"] = item.Id;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Locales_T
    {
        public DateTime Created { get; set; }
        public String Culture { get; set; }
        public String CurrentLocale { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public String DateFormat { get; set; }
        public String DateTimeFormat { get; set; }
        public Boolean Deleted { get; set; }
        public String Description { get; set; }
        public Int32 DescriptionID { get; set; }
        public String HelpFolder { get; set; }
        public String Locale { get; set; }
        public Int32 LocaleID { get; set; }
        public String NameFormat { get; set; }
        public String NumberFormat { get; set; }
        public Int32 SegmentID { get; set; }
        public Boolean SubmitOnEnter { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Locales_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Locales_TEnumerableExtension()
        {
            _DataTable = new DataTable("Locales_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("Culture", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentLocale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("DateFormat", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("DateTimeFormat", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Description", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("DescriptionID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("HelpFolder", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Locale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("LocaleID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("NameFormat", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("NumberFormat", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SubmitOnEnter", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<Locales_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Locales_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Locales_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["Culture"] = item.Culture;
            row["CurrentLocale"] = item.CurrentLocale;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["DateFormat"] = item.DateFormat;
            row["DateTimeFormat"] = item.DateTimeFormat;
            row["Deleted"] = item.Deleted;
            row["Description"] = item.Description;
            row["DescriptionID"] = item.DescriptionID;
            row["HelpFolder"] = item.HelpFolder;
            row["Locale"] = item.Locale;
            row["LocaleID"] = item.LocaleID;
            row["NameFormat"] = item.NameFormat;
            row["NumberFormat"] = item.NumberFormat;
            row["SegmentID"] = item.SegmentID;
            row["SubmitOnEnter"] = item.SubmitOnEnter;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class LocalesOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 DescriptionID { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class LocalesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static LocalesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("LocalesOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("DescriptionID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<LocalesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("LocalesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(LocalesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["DescriptionID"] = item.DescriptionID;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class LocalizationDataStringT
    {
        public String Locale { get; set; }
        public Int32 ObjectID { get; set; }
        public Int32 ObjectTypeID { get; set; }
        public Int32 SegmentId { get; set; }
        public String String { get; set; }
        public Int32 StringId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class LocalizationDataStringTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static LocalizationDataStringTEnumerableExtension()
        {
            _DataTable = new DataTable("LocalizationDataStringT");

            _DataTable.Columns.Add(new DataColumn("Locale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ObjectID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ObjectTypeID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("String", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("StringId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<LocalizationDataStringT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("LocalizationDataStringT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(LocalizationDataStringT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Locale"] = item.Locale;
            row["ObjectID"] = item.ObjectID;
            row["ObjectTypeID"] = item.ObjectTypeID;
            row["SegmentId"] = item.SegmentId;
            row["String"] = item.String;
            row["StringId"] = item.StringId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class LocalizationRefT
    {
        public Int32 ObjectID { get; set; }
        public Int32 ObjectTypeID { get; set; }
        public String PropertyName { get; set; }
        public Int32 StringId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class LocalizationRefTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static LocalizationRefTEnumerableExtension()
        {
            _DataTable = new DataTable("LocalizationRefT");

            _DataTable.Columns.Add(new DataColumn("ObjectID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ObjectTypeID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("PropertyName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("StringId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<LocalizationRefT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("LocalizationRefT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(LocalizationRefT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ObjectID"] = item.ObjectID;
            row["ObjectTypeID"] = item.ObjectTypeID;
            row["PropertyName"] = item.PropertyName;
            row["StringId"] = item.StringId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class MessageRecipients_T
    {
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public DateTime DeleteTime { get; set; }
        public Int32 MessageID { get; set; }
        public Int32 MessageRecipientID { get; set; }
        public DateTime ReceiptTime { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
        public Int32 UserID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class MessageRecipients_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static MessageRecipients_TEnumerableExtension()
        {
            _DataTable = new DataTable("MessageRecipients_T");

            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("DeleteTime", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("MessageID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("MessageRecipientID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ReceiptTime", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<MessageRecipients_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("MessageRecipients_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(MessageRecipients_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["DeleteTime"] = item.DeleteTime;
            row["MessageID"] = item.MessageID;
            row["MessageRecipientID"] = item.MessageRecipientID;
            row["ReceiptTime"] = item.ReceiptTime;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
            row["UserID"] = item.UserID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class MessageRecipientsOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class MessageRecipientsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static MessageRecipientsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("MessageRecipientsOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<MessageRecipientsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("MessageRecipientsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(MessageRecipientsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Messages_T
    {
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 MessageID { get; set; }
        public String MessageString { get; set; }
        public Int32 MessageStringID { get; set; }
        public String MessageStringKey { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Send { get; set; }
        public String StringParameters { get; set; }
        public String Subject { get; set; }
        public String SubjectStringKey { get; set; }
        public DateTime Updated { get; set; }
        public Int32 Urgency { get; set; }
        public String WhoFrom { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Messages_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Messages_TEnumerableExtension()
        {
            _DataTable = new DataTable("Messages_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("MessageID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("MessageString", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("MessageStringID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("MessageStringKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Send", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("StringParameters", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Subject", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SubjectStringKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("Urgency", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("WhoFrom", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<Messages_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Messages_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Messages_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["MessageID"] = item.MessageID;
            row["MessageString"] = item.MessageString;
            row["MessageStringID"] = item.MessageStringID;
            row["MessageStringKey"] = item.MessageStringKey;
            row["SegmentID"] = item.SegmentID;
            row["Send"] = item.Send;
            row["StringParameters"] = item.StringParameters;
            row["Subject"] = item.Subject;
            row["SubjectStringKey"] = item.SubjectStringKey;
            row["Updated"] = item.Updated;
            row["Urgency"] = item.Urgency;
            row["WhoFrom"] = item.WhoFrom;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class MessagesOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class MessagesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static MessagesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("MessagesOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<MessagesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("MessagesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(MessagesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ModuleActions_T
    {
        public Int32 ActionGroupId { get; set; }
        public Int32 ActionType { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ModuleActionID { get; set; }
        public Byte ModuleID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ModuleActions_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ModuleActions_TEnumerableExtension()
        {
            _DataTable = new DataTable("ModuleActions_T");

            _DataTable.Columns.Add(new DataColumn("ActionGroupId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ActionType", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ModuleActionID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ModuleID", typeof(Byte)));
        }

        public static DataTable ToDataTable(this IEnumerable<ModuleActions_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ModuleActions_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ModuleActions_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["ActionGroupId"] = item.ActionGroupId;
            row["ActionType"] = item.ActionType;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ModuleActionID"] = item.ModuleActionID;
            row["ModuleID"] = item.ModuleID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ModuleActionsOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ModuleActionsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ModuleActionsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ModuleActionsOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<ModuleActionsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ModuleActionsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ModuleActionsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ObjectSegments_T
    {
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean DefaultSegment { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ObjectId { get; set; }
        public Int32 ObjectSegmentId { get; set; }
        public Int32 ObjectTypeId { get; set; }
        public Boolean ReadOnly { get; set; }
        public Int32 SegmentId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ObjectSegments_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ObjectSegments_TEnumerableExtension()
        {
            _DataTable = new DataTable("ObjectSegments_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("DefaultSegment", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ObjectId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ObjectSegmentId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ReadOnly", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("SegmentId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<ObjectSegments_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ObjectSegments_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ObjectSegments_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["DefaultSegment"] = item.DefaultSegment;
            row["Deleted"] = item.Deleted;
            row["ObjectId"] = item.ObjectId;
            row["ObjectSegmentId"] = item.ObjectSegmentId;
            row["ObjectTypeId"] = item.ObjectTypeId;
            row["ReadOnly"] = item.ReadOnly;
            row["SegmentId"] = item.SegmentId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class ObjectSegmentsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class ObjectSegmentsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static ObjectSegmentsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("ObjectSegmentsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<ObjectSegmentsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("ObjectSegmentsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(ObjectSegmentsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class RoleActions_T
    {
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ModuleActionId { get; set; }
        public Int64 RestrictionMask { get; set; }
        public Int64 RestrictionStatus { get; set; }
        public Int32 RoleActionID { get; set; }
        public Int16 RoleID { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class RoleActions_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static RoleActions_TEnumerableExtension()
        {
            _DataTable = new DataTable("RoleActions_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ModuleActionId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RestrictionMask", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("RestrictionStatus", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("RoleActionID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RoleID", typeof(Int16)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<RoleActions_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("RoleActions_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(RoleActions_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ModuleActionId"] = item.ModuleActionId;
            row["RestrictionMask"] = item.RestrictionMask;
            row["RestrictionStatus"] = item.RestrictionStatus;
            row["RoleActionID"] = item.RoleActionID;
            row["RoleID"] = item.RoleID;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class RoleActionsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class RoleActionsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static RoleActionsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("RoleActionsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<RoleActionsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("RoleActionsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(RoleActionsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Roles_T
    {
        public Boolean Active { get; set; }
        public DateTime Created { get; set; }
        public String CurrentLocale { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 ModuleId { get; set; }
        public String OID { get; set; }
        public Int32 RoleID { get; set; }
        public String RoleName { get; set; }
        public Int32 RoleNameID { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Roles_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Roles_TEnumerableExtension()
        {
            _DataTable = new DataTable("Roles_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentLocale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ModuleId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OID", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("RoleID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RoleName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("RoleNameID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<Roles_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Roles_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Roles_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["Created"] = item.Created;
            row["CurrentLocale"] = item.CurrentLocale;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ModuleId"] = item.ModuleId;
            row["OID"] = item.OID;
            row["RoleID"] = item.RoleID;
            row["RoleName"] = item.RoleName;
            row["RoleNameID"] = item.RoleNameID;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class RolesOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public Int32 RoleNameID { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class RolesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static RolesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("RolesOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RoleNameID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<RolesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("RolesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(RolesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["RoleNameID"] = item.RoleNameID;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SearchResultType
    {
        public Int32 LevelOrdinal { get; set; }
        public Decimal Rank { get; set; }
        public Byte RecursionDepth { get; set; }
        public Int64 TermId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SearchResultTypeEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SearchResultTypeEnumerableExtension()
        {
            _DataTable = new DataTable("SearchResultType");

            _DataTable.Columns.Add(new DataColumn("LevelOrdinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Rank", typeof(Decimal)));
            _DataTable.Columns.Add(new DataColumn("RecursionDepth", typeof(Byte)));
            _DataTable.Columns.Add(new DataColumn("TermId", typeof(Int64)));
        }

        public static DataTable ToDataTable(this IEnumerable<SearchResultType> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SearchResultType.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SearchResultType item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["LevelOrdinal"] = item.LevelOrdinal;
            row["Rank"] = item.Rank;
            row["RecursionDepth"] = item.RecursionDepth;
            row["TermId"] = item.TermId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityGroups_T
    {
        public Boolean Active { get; set; }
        public DateTime Created { get; set; }
        public String CurrentLocale { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String Name { get; set; }
        public Int32 SecurityGroupID { get; set; }
        public Int32 SecurityGroupnameID { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityGroups_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityGroups_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityGroups_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentLocale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Name", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SecurityGroupID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SecurityGroupnameID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityGroups_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityGroups_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityGroups_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["Created"] = item.Created;
            row["CurrentLocale"] = item.CurrentLocale;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["Name"] = item.Name;
            row["SecurityGroupID"] = item.SecurityGroupID;
            row["SecurityGroupnameID"] = item.SecurityGroupnameID;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityGroupsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public Int32 SecurityGroupnameID { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityGroupsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityGroupsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityGroupsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SecurityGroupnameID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityGroupsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityGroupsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityGroupsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["SecurityGroupnameID"] = item.SecurityGroupnameID;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityGroupUsers_T
    {
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 SecurityGroupID { get; set; }
        public Int32 SecurityGroupUserID { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
        public Int32 UserID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityGroupUsers_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityGroupUsers_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityGroupUsers_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("SecurityGroupID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SecurityGroupUserID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityGroupUsers_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityGroupUsers_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityGroupUsers_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["SecurityGroupID"] = item.SecurityGroupID;
            row["SecurityGroupUserID"] = item.SecurityGroupUserID;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
            row["UserID"] = item.UserID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityGroupUsersOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityGroupUsersOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityGroupUsersOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityGroupUsersOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityGroupUsersOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityGroupUsersOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityGroupUsersOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityModules_T
    {
        public Boolean Active { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Byte ModuleId { get; set; }
        public String ModuleName { get; set; }
        public Int32 ObjectTypeID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityModules_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityModules_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityModules_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ModuleId", typeof(Byte)));
            _DataTable.Columns.Add(new DataColumn("ModuleName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ObjectTypeID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityModules_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityModules_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityModules_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["ModuleId"] = item.ModuleId;
            row["ModuleName"] = item.ModuleName;
            row["ObjectTypeID"] = item.ObjectTypeID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SecurityModulesOut_T
    {
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SecurityModulesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SecurityModulesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("SecurityModulesOut_T");

            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<SecurityModulesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SecurityModulesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SecurityModulesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Segments_T
    {
        public Boolean Active { get; set; }
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public String IMedidataId { get; set; }
        public String OID { get; set; }
        public Int32 SegmentId { get; set; }
        public String SegmentName { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Segments_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Segments_TEnumerableExtension()
        {
            _DataTable = new DataTable("Segments_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IMedidataId", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("OID", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SegmentName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<Segments_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Segments_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Segments_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["IMedidataId"] = item.IMedidataId;
            row["OID"] = item.OID;
            row["SegmentId"] = item.SegmentId;
            row["SegmentName"] = item.SegmentName;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SegmentsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SegmentsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SegmentsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("SegmentsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<SegmentsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SegmentsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SegmentsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class SynonymResultType
    {
        public Decimal MatchPercent { get; set; }
        public Int32 SynonymTermId { get; set; }
        public Int32 TermId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class SynonymResultTypeEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static SynonymResultTypeEnumerableExtension()
        {
            _DataTable = new DataTable("SynonymResultType");

            _DataTable.Columns.Add(new DataColumn("MatchPercent", typeof(Decimal)));
            _DataTable.Columns.Add(new DataColumn("SynonymTermId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("TermId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<SynonymResultType> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("SynonymResultType.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(SynonymResultType item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["MatchPercent"] = item.MatchPercent;
            row["SynonymTermId"] = item.SynonymTermId;
            row["TermId"] = item.TermId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TaskInsert_UDT
    {
        public String BatchOID { get; set; }
        public String CodingContextURI { get; set; }
        public Int32 CodingRequestItemDataOrdinal { get; set; }
        public String DictionaryLocale { get; set; }
        public String FieldRef { get; set; }
        public String FormRef { get; set; }
        public Int32 GroupId { get; set; }
        public Boolean IsSynchronousAckNack { get; set; }
        public String LineRef { get; set; }
        public String MarkingGroup { get; set; }
        public String MedicalDictionaryLevelKey { get; set; }
        public Int32 Priority { get; set; }
        public String RawInputString { get; set; }
        public Int32 ReducedInputStringId { get; set; }
        public String SiteRef { get; set; }
        public String SourceIdentifier { get; set; }
        public Int32 StartingWorkflowStateId { get; set; }
        public Int32 StudyDictionaryVersionId { get; set; }
        public String SubjectRef { get; set; }
        public Int32 TermSearchType { get; set; }
        public Int64 UpdatedTimeStamp { get; set; }
        public String UUID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TaskInsert_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TaskInsert_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("TaskInsert_UDT");

            _DataTable.Columns.Add(new DataColumn("BatchOID", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CodingContextURI", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CodingRequestItemDataOrdinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("DictionaryLocale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("FieldRef", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("FormRef", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("GroupId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("IsSynchronousAckNack", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("LineRef", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("MarkingGroup", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("MedicalDictionaryLevelKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Priority", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RawInputString", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ReducedInputStringId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SiteRef", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SourceIdentifier", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("StartingWorkflowStateId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("StudyDictionaryVersionId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SubjectRef", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("TermSearchType", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("UpdatedTimeStamp", typeof(Int64)));
            _DataTable.Columns.Add(new DataColumn("UUID", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<TaskInsert_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TaskInsert_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TaskInsert_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["BatchOID"] = item.BatchOID;
            row["CodingContextURI"] = item.CodingContextURI;
            row["CodingRequestItemDataOrdinal"] = item.CodingRequestItemDataOrdinal;
            row["DictionaryLocale"] = item.DictionaryLocale;
            row["FieldRef"] = item.FieldRef;
            row["FormRef"] = item.FormRef;
            row["GroupId"] = item.GroupId;
            row["IsSynchronousAckNack"] = item.IsSynchronousAckNack;
            row["LineRef"] = item.LineRef;
            row["MarkingGroup"] = item.MarkingGroup;
            row["MedicalDictionaryLevelKey"] = item.MedicalDictionaryLevelKey;
            row["Priority"] = item.Priority;
            row["RawInputString"] = item.RawInputString;
            row["ReducedInputStringId"] = item.ReducedInputStringId;
            row["SiteRef"] = item.SiteRef;
            row["SourceIdentifier"] = item.SourceIdentifier;
            row["StartingWorkflowStateId"] = item.StartingWorkflowStateId;
            row["StudyDictionaryVersionId"] = item.StudyDictionaryVersionId;
            row["SubjectRef"] = item.SubjectRef;
            row["TermSearchType"] = item.TermSearchType;
            row["UpdatedTimeStamp"] = item.UpdatedTimeStamp;
            row["UUID"] = item.UUID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermArrayType
    {
        public Int64 TermId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermArrayTypeEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermArrayTypeEnumerableExtension()
        {
            _DataTable = new DataTable("TermArrayType");

            _DataTable.Columns.Add(new DataColumn("TermId", typeof(Int64)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermArrayType> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermArrayType.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermArrayType item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["TermId"] = item.TermId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermBase_UDT
    {
        public String LevelKey { get; set; }
        public Int32 Ordinal { get; set; }
        public String TermPath { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermBase_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermBase_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("TermBase_UDT");

            _DataTable.Columns.Add(new DataColumn("LevelKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Ordinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("TermPath", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermBase_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermBase_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermBase_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["LevelKey"] = item.LevelKey;
            row["Ordinal"] = item.Ordinal;
            row["TermPath"] = item.TermPath;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermComponent_UDT
    {
        public Int32 CodingRequestItemDataOrdinal { get; set; }
        public Int32 Id { get; set; }
        public Boolean IsSupplement { get; set; }
        public String OID { get; set; }
        public Int32 Ordinal { get; set; }
        public String RawInputString { get; set; }
        public Int32 ReducedInputStringId { get; set; }
        public String TextKey { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermComponent_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermComponent_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("TermComponent_UDT");

            _DataTable.Columns.Add(new DataColumn("CodingRequestItemDataOrdinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("IsSupplement", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("OID", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Ordinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RawInputString", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("ReducedInputStringId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("TextKey", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermComponent_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermComponent_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermComponent_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CodingRequestItemDataOrdinal"] = item.CodingRequestItemDataOrdinal;
            row["Id"] = item.Id;
            row["IsSupplement"] = item.IsSupplement;
            row["OID"] = item.OID;
            row["Ordinal"] = item.Ordinal;
            row["RawInputString"] = item.RawInputString;
            row["ReducedInputStringId"] = item.ReducedInputStringId;
            row["TextKey"] = item.TextKey;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermPercent_UDT
    {
        public Decimal MatchPercent { get; set; }
        public Int32 TermId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermPercent_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermPercent_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("TermPercent_UDT");

            _DataTable.Columns.Add(new DataColumn("MatchPercent", typeof(Decimal)));
            _DataTable.Columns.Add(new DataColumn("TermId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermPercent_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermPercent_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermPercent_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["MatchPercent"] = item.MatchPercent;
            row["TermId"] = item.TermId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermReference_UDT
    {
        public Int32 CodingRequestItemDataOrdinal { get; set; }
        public String ReferenceKey { get; set; }
        public String Value { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermReference_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermReference_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("TermReference_UDT");

            _DataTable.Columns.Add(new DataColumn("CodingRequestItemDataOrdinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ReferenceKey", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Value", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermReference_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermReference_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermReference_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CodingRequestItemDataOrdinal"] = item.CodingRequestItemDataOrdinal;
            row["ReferenceKey"] = item.ReferenceKey;
            row["Value"] = item.Value;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class TermSearchResultType
    {
        public Int32 LevelId { get; set; }
        public String NodePath { get; set; }
        public Decimal Rank { get; set; }
        public Byte RecursionDepth { get; set; }
        public Int32 TermId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class TermSearchResultTypeEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static TermSearchResultTypeEnumerableExtension()
        {
            _DataTable = new DataTable("TermSearchResultType");

            _DataTable.Columns.Add(new DataColumn("LevelId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("NodePath", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Rank", typeof(Decimal)));
            _DataTable.Columns.Add(new DataColumn("RecursionDepth", typeof(Byte)));
            _DataTable.Columns.Add(new DataColumn("TermId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<TermSearchResultType> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("TermSearchResultType.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(TermSearchResultType item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["LevelId"] = item.LevelId;
            row["NodePath"] = item.NodePath;
            row["Rank"] = item.Rank;
            row["RecursionDepth"] = item.RecursionDepth;
            row["TermId"] = item.TermId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class UserObjectRoles_T
    {
        public Boolean Active { get; set; }
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Boolean DenyObjectRole { get; set; }
        public Int32 GrantOnObjectId { get; set; }
        public Int32 GrantOnObjectTypeId { get; set; }
        public Int32 GrantToObjectId { get; set; }
        public Int32 GrantToObjectTypeId { get; set; }
        public Int16 RoleID { get; set; }
        public Int32 SegmentID { get; set; }
        public DateTime Updated { get; set; }
        public Int32 UserObjectRoleId { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class UserObjectRoles_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static UserObjectRoles_TEnumerableExtension()
        {
            _DataTable = new DataTable("UserObjectRoles_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("DenyObjectRole", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("GrantOnObjectId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("GrantOnObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("GrantToObjectId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("GrantToObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("RoleID", typeof(Int16)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserObjectRoleId", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<UserObjectRoles_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("UserObjectRoles_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(UserObjectRoles_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["DenyObjectRole"] = item.DenyObjectRole;
            row["GrantOnObjectId"] = item.GrantOnObjectId;
            row["GrantOnObjectTypeId"] = item.GrantOnObjectTypeId;
            row["GrantToObjectId"] = item.GrantToObjectId;
            row["GrantToObjectTypeId"] = item.GrantToObjectTypeId;
            row["RoleID"] = item.RoleID;
            row["SegmentID"] = item.SegmentID;
            row["Updated"] = item.Updated;
            row["UserObjectRoleId"] = item.UserObjectRoleId;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class UserObjectRolesOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class UserObjectRolesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static UserObjectRolesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("UserObjectRolesOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<UserObjectRolesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("UserObjectRolesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(UserObjectRolesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class Users_T
    {
        public Boolean AccountActivation { get; set; }
        public Boolean Active { get; set; }
        public Int32 AuthenticationSourceID { get; set; }
        public Int32 AuthenticatorID { get; set; }
        public DateTime Created { get; set; }
        public Int32 CreatedBy { get; set; }
        public String Credentials { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public String DEANumber { get; set; }
        public Int32 DefaultSegmentID { get; set; }
        public Boolean Deleted { get; set; }
        public String Email { get; set; }
        public DateTime EULADate { get; set; }
        public Int32 ExternalID { get; set; }
        public String FirstName { get; set; }
        public Int32 GlobalRoleID { get; set; }
        public String IMedidataId { get; set; }
        public Boolean IsClinicalUser { get; set; }
        public Boolean IsEnabled { get; set; }
        public Boolean IsLockedOut { get; set; }
        public Boolean IsReadOnly { get; set; }
        public Boolean IsSponsorApprovalRequired { get; set; }
        public Boolean IsTrainingOnly { get; set; }
        public Boolean IsTrainingSigned { get; set; }
        public String LastName { get; set; }
        public String Locale { get; set; }
        public String Login { get; set; }
        public String MiddleName { get; set; }
        public String Password { get; set; }
        public DateTime PasswordExpires { get; set; }
        public String PIN { get; set; }
        public String Salt { get; set; }
        public String Salutation { get; set; }
        public String Title { get; set; }
        public DateTime Updated { get; set; }
        public Int32 UserID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class Users_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static Users_TEnumerableExtension()
        {
            _DataTable = new DataTable("Users_T");

            _DataTable.Columns.Add(new DataColumn("AccountActivation", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("AuthenticationSourceID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("AuthenticatorID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CreatedBy", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Credentials", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("DEANumber", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("DefaultSegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Email", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("EULADate", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("ExternalID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("FirstName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("GlobalRoleID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("IMedidataId", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("IsClinicalUser", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsEnabled", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsLockedOut", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsReadOnly", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsSponsorApprovalRequired", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsTrainingOnly", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsTrainingSigned", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("LastName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Locale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Login", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("MiddleName", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Password", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("PasswordExpires", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("PIN", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Salt", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Salutation", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Title", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<Users_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("Users_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(Users_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["AccountActivation"] = item.AccountActivation;
            row["Active"] = item.Active;
            row["AuthenticationSourceID"] = item.AuthenticationSourceID;
            row["AuthenticatorID"] = item.AuthenticatorID;
            row["Created"] = item.Created;
            row["CreatedBy"] = item.CreatedBy;
            row["Credentials"] = item.Credentials;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["DEANumber"] = item.DEANumber;
            row["DefaultSegmentID"] = item.DefaultSegmentID;
            row["Deleted"] = item.Deleted;
            row["Email"] = item.Email;
            row["EULADate"] = item.EULADate;
            row["ExternalID"] = item.ExternalID;
            row["FirstName"] = item.FirstName;
            row["GlobalRoleID"] = item.GlobalRoleID;
            row["IMedidataId"] = item.IMedidataId;
            row["IsClinicalUser"] = item.IsClinicalUser;
            row["IsEnabled"] = item.IsEnabled;
            row["IsLockedOut"] = item.IsLockedOut;
            row["IsReadOnly"] = item.IsReadOnly;
            row["IsSponsorApprovalRequired"] = item.IsSponsorApprovalRequired;
            row["IsTrainingOnly"] = item.IsTrainingOnly;
            row["IsTrainingSigned"] = item.IsTrainingSigned;
            row["LastName"] = item.LastName;
            row["Locale"] = item.Locale;
            row["Login"] = item.Login;
            row["MiddleName"] = item.MiddleName;
            row["Password"] = item.Password;
            row["PasswordExpires"] = item.PasswordExpires;
            row["PIN"] = item.PIN;
            row["Salt"] = item.Salt;
            row["Salutation"] = item.Salutation;
            row["Title"] = item.Title;
            row["Updated"] = item.Updated;
            row["UserID"] = item.UserID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class UserSettings_T
    {
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Boolean IsUserConfigurable { get; set; }
        public Int32 SegmentID { get; set; }
        public String Tag { get; set; }
        public DateTime Updated { get; set; }
        public Int32 UserID { get; set; }
        public Int32 UserSettingID { get; set; }
        public String Value { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class UserSettings_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static UserSettings_TEnumerableExtension()
        {
            _DataTable = new DataTable("UserSettings_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsUserConfigurable", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Tag", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("UserID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("UserSettingID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Value", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<UserSettings_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("UserSettings_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(UserSettings_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["IsUserConfigurable"] = item.IsUserConfigurable;
            row["SegmentID"] = item.SegmentID;
            row["Tag"] = item.Tag;
            row["Updated"] = item.Updated;
            row["UserID"] = item.UserID;
            row["UserSettingID"] = item.UserSettingID;
            row["Value"] = item.Value;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class UserSettingsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class UserSettingsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static UserSettingsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("UserSettingsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<UserSettingsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("UserSettingsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(UserSettingsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class UsersOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class UsersOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static UsersOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("UsersOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<UsersOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("UsersOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(UsersOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WelcomeMessages_T
    {
        public Boolean Active { get; set; }
        public Boolean AllRoles { get; set; }
        public Boolean AllStudies { get; set; }
        public DateTime Created { get; set; }
        public String CurrentLocale { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Int32 SegmentID { get; set; }
        public Boolean ShowAtSiteLevel { get; set; }
        public Boolean ShowAtStudyLevel { get; set; }
        public Boolean ShowAtTopLevel { get; set; }
        public String StaticText { get; set; }
        public DateTime Updated { get; set; }
        public Int32 WelcomeMessage { get; set; }
        public Int32 WelcomeMessageID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WelcomeMessages_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WelcomeMessages_TEnumerableExtension()
        {
            _DataTable = new DataTable("WelcomeMessages_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("AllRoles", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("AllStudies", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentLocale", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("ShowAtSiteLevel", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ShowAtStudyLevel", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("ShowAtTopLevel", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("StaticText", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("WelcomeMessage", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("WelcomeMessageID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<WelcomeMessages_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WelcomeMessages_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WelcomeMessages_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["AllRoles"] = item.AllRoles;
            row["AllStudies"] = item.AllStudies;
            row["Created"] = item.Created;
            row["CurrentLocale"] = item.CurrentLocale;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["SegmentID"] = item.SegmentID;
            row["ShowAtSiteLevel"] = item.ShowAtSiteLevel;
            row["ShowAtStudyLevel"] = item.ShowAtStudyLevel;
            row["ShowAtTopLevel"] = item.ShowAtTopLevel;
            row["StaticText"] = item.StaticText;
            row["Updated"] = item.Updated;
            row["WelcomeMessage"] = item.WelcomeMessage;
            row["WelcomeMessageID"] = item.WelcomeMessageID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WelcomeMessagesOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
        public Int32 WelcomeMessage { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WelcomeMessagesOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WelcomeMessagesOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("WelcomeMessagesOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("WelcomeMessage", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<WelcomeMessagesOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WelcomeMessagesOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WelcomeMessagesOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
            row["WelcomeMessage"] = item.WelcomeMessage;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WelcomeMessageTags_T
    {
        public Boolean Active { get; set; }
        public DateTime Created { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Boolean Deleted { get; set; }
        public Boolean IsPriority { get; set; }
        public String MessageTag { get; set; }
        public Int32 SegmentID { get; set; }
        public String SQLFunction { get; set; }
        public DateTime Updated { get; set; }
        public Int32 WelcomeMessageTagID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WelcomeMessageTags_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WelcomeMessageTags_TEnumerableExtension()
        {
            _DataTable = new DataTable("WelcomeMessageTags_T");

            _DataTable.Columns.Add(new DataColumn("Active", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Deleted", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("IsPriority", typeof(Boolean)));
            _DataTable.Columns.Add(new DataColumn("MessageTag", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("SegmentID", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("SQLFunction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("WelcomeMessageTagID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<WelcomeMessageTags_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WelcomeMessageTags_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WelcomeMessageTags_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Active"] = item.Active;
            row["Created"] = item.Created;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Deleted"] = item.Deleted;
            row["IsPriority"] = item.IsPriority;
            row["MessageTag"] = item.MessageTag;
            row["SegmentID"] = item.SegmentID;
            row["SQLFunction"] = item.SQLFunction;
            row["Updated"] = item.Updated;
            row["WelcomeMessageTagID"] = item.WelcomeMessageTagID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WelcomeMessageTagsOut_T
    {
        public DateTime Created { get; set; }
        public String CurrentAction { get; set; }
        public Int32 CurrentObjectTypeId { get; set; }
        public Int32 Id { get; set; }
        public Int32 OldId { get; set; }
        public DateTime Updated { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WelcomeMessageTagsOut_TEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WelcomeMessageTagsOut_TEnumerableExtension()
        {
            _DataTable = new DataTable("WelcomeMessageTagsOut_T");

            _DataTable.Columns.Add(new DataColumn("Created", typeof(DateTime)));
            _DataTable.Columns.Add(new DataColumn("CurrentAction", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("CurrentObjectTypeId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("OldId", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Updated", typeof(DateTime)));
        }

        public static DataTable ToDataTable(this IEnumerable<WelcomeMessageTagsOut_T> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WelcomeMessageTagsOut_T.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WelcomeMessageTagsOut_T item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["Created"] = item.Created;
            row["CurrentAction"] = item.CurrentAction;
            row["CurrentObjectTypeId"] = item.CurrentObjectTypeId;
            row["Id"] = item.Id;
            row["OldId"] = item.OldId;
            row["Updated"] = item.Updated;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WorkflowStateIds_UDT
    {
        public Int32 WorkflowStateID { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WorkflowStateIds_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WorkflowStateIds_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("WorkflowStateIds_UDT");

            _DataTable.Columns.Add(new DataColumn("WorkflowStateID", typeof(Int32)));
        }

        public static DataTable ToDataTable(this IEnumerable<WorkflowStateIds_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WorkflowStateIds_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WorkflowStateIds_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["WorkflowStateID"] = item.WorkflowStateID;
        }
    }

    [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal class WorkflowVariable_UDT
    {
        public Int32 CodingRequestItemDataOrdinal { get; set; }
        public Int32 Id { get; set; }
        public String Name { get; set; }
        public String Value { get; set; }
	
     }

     [GeneratedByMedidataDapper]
[GeneratedCode("T4 medidata-dapper-dot-net","0.0.7")]
    internal static class WorkflowVariable_UDTEnumerableExtension
    {
        private static readonly DataTable _DataTable;
        private static readonly Int32     _UDTRowLimit = 5000;

        static WorkflowVariable_UDTEnumerableExtension()
        {
            _DataTable = new DataTable("WorkflowVariable_UDT");

            _DataTable.Columns.Add(new DataColumn("CodingRequestItemDataOrdinal", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Id", typeof(Int32)));
            _DataTable.Columns.Add(new DataColumn("Name", typeof(String)));
            _DataTable.Columns.Add(new DataColumn("Value", typeof(String)));
        }

        public static DataTable ToDataTable(this IEnumerable<WorkflowVariable_UDT> items)
        {
            Debug.Assert(!ReferenceEquals(items, null), "items can't be null");

            if(ReferenceEquals(items, null))
                throw new ArgumentNullException("items");

            var table = _DataTable.Clone();

            if (items.Count() > _UDTRowLimit)
                throw new ArgumentOutOfRangeException(string.Format("WorkflowVariable_UDT.ToDataTable() Error: More than {0} data rows populated to data table which is beyond the upper limit.", _UDTRowLimit));

            foreach (var item in items)
            {
                var row = table.NewRow();
                PopulateToDataRow(item, row);
                table.Rows.Add(row);
            }
            return table;
        }

        private static void PopulateToDataRow(WorkflowVariable_UDT item, DataRow row)
        {
            Debug.Assert(!ReferenceEquals(item, null), "item can't be null");
            Debug.Assert(!ReferenceEquals(row , null), "row can't be null");

            row["CodingRequestItemDataOrdinal"] = item.CodingRequestItemDataOrdinal;
            row["Id"] = item.Id;
            row["Name"] = item.Name;
            row["Value"] = item.Value;
        }
    }

}
