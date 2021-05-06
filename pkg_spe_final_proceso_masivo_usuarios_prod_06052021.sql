create or replace package pkg_manage_user_ipacs is


  procedure p_relation_user_role(p_user_id  in NVARCHAR2,
                                 p_role     in VARCHAR2,
                                 p_priority in INTEGER);

  procedure p_unrelation_user_role(p_user_id  in NVARCHAR2,
                                 p_role     in VARCHAR2,
                                 p_priority in INTEGER

                                 );



  procedure P_MAXIVE_INSERT_USER_ROL_HORIZONTAL;
  procedure p_maxive_update_user_rol_horizontal;
  procedure p_maxive_unable_user_rol_horizontal;

end pkg_manage_user_ipacs;
