create or replace package body pkg_manage_user_ipacs is

  
  --==============================================================================================================================

  procedure p_relation_user_role(p_user_id  in NVARCHAR2,
                                 p_role     in VARCHAR2,
                                 p_priority in INTEGER

                                 ) is
    v_user_id varchar2(100);
    v_role    varchar2(100);
    contador  number := 1;
  BEGIN

    begin
      select user_id, role
        into v_user_id, v_role
        from ipacs.snd_user_roles@DBLNK545
       where user_id = p_user_id
         and role = p_role;
         dbms_output.put_line('El usuario:, '||p_user_id ||', ya contaba con el Rol:,'||p_role||chr(9));
         insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',p_user_id,' ya contaba con el Rol', p_role);

    exception
      when no_data_found then

        INSERT INTO ipacs.snd_user_roles@DBLNK545
          (user_id, role, priority)
        VALUES
          (p_user_id, p_role, p_priority);
        dbms_output.put_line('El usuario:, '||p_user_id ||', se le agrego el Rol:,'||p_role||chr(9));
        insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',p_user_id,' se le agrego el Rol', p_role);
    end;

  END;

    procedure p_unrelation_user_role(p_user_id  in NVARCHAR2,
                                 p_role     in VARCHAR2,
                                 p_priority in INTEGER

                                 ) is
    v_user_id varchar2(100);
    v_role    varchar2(100);
    contador  number := 1;
  BEGIN

    begin
      select user_id, role
        into v_user_id, v_role
        from ipacs.snd_user_roles@DBLNK545
       where user_id = p_user_id
         and role = p_role;


delete from  ipacs.snd_user_roles@DBLNK545
where user_id = p_user_id
and role = p_role;

        dbms_output.put_line('El usuario:, '||p_user_id ||', se le elimino el Rol:,'||p_role||chr(9));
        insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',p_user_id,' se le elimino el Rol', p_role);
    exception
      when no_data_found then

         dbms_output.put_line('El usuario:, '||p_user_id ||', no contaba con el Rol:,'||p_role||chr(9));
         insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',p_user_id,' no contaba con el Rol', p_role);


    end;

  END;

    --==============================================================================================================================
  /*
     create table SND_USER_TEMP
  (
    user_id   VARCHAR2(200),
    nombre   VARCHAR2(200),
    apellido VARCHAR2(500),
    email    VARCHAR2(500),
    rol  VARCHAR2(500),
    user_category  number
  )
  */



procedure P_MAXIVE_INSERT_USER_ROL_HORIZONTAL
  is
    usuario_v   varchar2(200);
    REG_DESPUES number;
    contador    NUMBER := 1;
    verified number;
    v_user_id varchar2(200);
    v_user_id_2do varchar2(200);
    user_exist number;
    es_el_mismo number:=0;
    usuario_v_rol varchar2(200);
    correo_armado varchar2(200);
begin

  for i in (select a.user_id,
                   a.user_desc,
                   a.user_password,
                   a.enabled,
                   a.add_by,
                   a.add_date,
                   a.mod_by,
                   a.mod_date,
                   a.last_passwrod_change_date,
                   a.default_password,
                   a.last_login_date,
                   a.block_user_count,
                   a.user_last_name,
                   a.otp_flag,
                   a.firebase_token,
                   a.user_name,
                   b.user_type_id,
                   b.user_zone_id,
                   b.user_hub_id,
                   b.user_area_id,
                   b.user_contact_no,
                   b.user_email_id,
                   b.user_address1,
                   b.user_address2,
                   b.user_address3,
                   b.user_postal_code,
                   b.user_parent_id,
                   b.user_status,
                   b.user_longitude,
                   b.user_latitude,
                   b.comments,
                   b.suspend_id,
                   b.user_secondary_contact,
                   b.staff,
                   b.user_agency,
                   b.postal_code,
                   b.pin_no,
                   b.vat_no,
                   b.national_id,
                   b.start_date,
                   b.end_date,
                   b.dept,
                   b.activator_name,
                   b.post,
                   b.owner_name,
                   b.activation_code,
                   b.user_category,
                   b.dob,
                   b.user_loc_id,
                   b.suspend_remarks,
                   b.danger_zone,
                   b.first_name,
                   b.last_name,
                   b.observations,
                   b.rubro
              from IPACS.SND_USER_LOGIN_DETAIL@DBLNK545 a, ipacs.snd_user_detail@DBLNK545 b
             where a.user_id = b.user_id
               and a.user_id like 'DEEPAK') loop

    for x in (select distinct upper(trim(nombre)) nombre,
                              upper(trim(apellido)) apellido,
                              upper(trim(user_id)) user_id,
                              upper(trim(email)) email,
                              upper(trim(user_category)) user_category
                from gg_admin.SND_USER_TEMP
               order by nombre desc) loop

      if (x.user_id is not null) and (x.email is null)  then
      correo_armado:= trim(upper(x.user_id))||upper('@att.com');
      end if;

      begin
    --valida si existe y si es el mismo
    select user_id
      into v_user_id
      from (select user_id
              from ipacs.snd_user_detail@DBLNK545
             where trim(upper(first_name)) = trim(upper(x.nombre))
               and trim(upper(last_name)) = trim(upper(x.apellido))
             order by start_date desc)
     where rownum = 1;

     begin
         select user_id
          into v_user_id_2do
          from (select user_id
                  from ipacs.snd_user_detail@DBLNK545
                 where trim(upper(first_name)) = trim(upper(x.nombre))
                   and trim(upper(last_name)) = trim(upper(x.apellido))
                   and trim(upper(user_email_id)) = trim(upper(x.email))
                 order by start_date desc)
         where rownum = 1;
         es_el_mismo := 1;
         dbms_output.put_line('El usuario:, '||v_user_id_2do ||'-'||x.nombre ||' '||x.apellido ||', ya existia*, Se valida contra el usuario en sistema y se confirma que es el mismo'||','||x.email||chr(9));
         insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , v_user_id_2do)||'-'||x.nombre ||' '||x.apellido,' ya existia*, Se valida contra el usuario en sistema y se confirma que es el mismo', x.email);

     exception
           when others then
             es_el_mismo := 0;
     end;

    user_exist:= 1;

    exception
      when others then
      usuario_v := substr(x.nombre, 1, 1) || x.apellido ||SUBSTR(v_user_id,- 1);
      es_el_mismo := 0;
      verified := 1;
     end;

  if user_exist = 1 and es_el_mismo = 0 then
    begin
    usuario_v := substr(x.nombre, 1, 1) || x.apellido ||(SUBSTR(v_user_id,- 1)+1);
    exception
      when  others then
        usuario_v := substr(x.nombre, 1, 1) || x.apellido ||'1' ;
        end;
    verified := 1;
  end if;

  if verified = 1 and es_el_mismo = 0 then

      begin
        begin
        insert into IPACS.SND_USER_LOGIN_DETAIL@DBLNK545
          (user_id,
           user_desc,
           user_password,
           enabled,
           add_by,
           add_date,
           mod_by,
           mod_date,
           last_passwrod_change_date,
           default_password,
           last_login_date,
           block_user_count,
           user_last_name,
           otp_flag,
           firebase_token,
           user_name)
        values
          (nvl(x.user_id , usuario_v),
           x.nombre || ' ' || x.apellido,
           '$2a$10$T8JIikakT7g4UW171cnVFeEUQQgTtbsOhE5a3A/byNtE4bdXMPv2S',
           i.enabled,
           i.add_by,
           i.add_date,
           i.mod_by,
           i.mod_date,
           i.last_passwrod_change_date,
           NULL,
           i.last_login_date,
           i.block_user_count,
           x.apellido,
           i.otp_flag,
           i.firebase_token,
           usuario_v);

        insert into ipacs.snd_user_detail@DBLNK545
          (user_id,
           user_type_id,
           user_zone_id,
           user_hub_id,
           user_area_id,
           user_contact_no,
           user_email_id,
           user_address1,
           user_address2,
           user_address3,
           user_postal_code,
           user_parent_id,
           user_status,
           user_longitude,
           user_latitude,
           comments,
           suspend_id,
           user_secondary_contact,
           add_by,
           staff,
           user_agency,
           postal_code,
           pin_no,
           vat_no,
           national_id,
           start_date,
           end_date,
           dept,
           activator_name,
           post,
           owner_name,
           activation_code,
           user_category,
           dob,
           user_loc_id,
           suspend_remarks,
           danger_zone,
           first_name,
           last_name,
           observations,
           rubro)
        values
          (nvl(x.user_id , usuario_v),
           i.user_type_id,
           i.user_zone_id,
           i.user_hub_id,
           i.user_area_id,
           i.user_contact_no,
           trim(upper(nvl(x.email, correo_armado))),
           'MGR'||trunc(sysdate),
           i.user_address2,
           i.user_address3,
           i.user_postal_code,
           i.user_parent_id,
           i.user_status,
           i.user_longitude,
           i.user_latitude,
           i.comments,
           i.suspend_id,
           i.user_secondary_contact,
           i.add_by,
           i.staff,
           i.user_agency,
           i.postal_code,
           i.pin_no,
           i.vat_no,
           i.national_id,
           i.start_date,
           i.end_date,
           i.dept,
           i.activator_name,
           i.post,
           i.owner_name,
           i.activation_code,
           nvl(x.user_category, i.user_category),
           i.dob,
           i.user_loc_id,
           i.suspend_remarks,
           i.danger_zone,
           x.nombre,
           x.apellido,
           i.observations,
           i.rubro);
           dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido ||', es creado'||','||x.email||chr(9));
           insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido,' es creado', x.email);
           exception
             when others then
               dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v) ||'-'||x.nombre ||' '||x.apellido ||', ya existia*'||','||x.email||chr(9));
               insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido,' ya existia*', x.email);
             end;

           for y in (
                    select trim(upper(ROL_HORINZONTAL_1)) ROL_HORINZONTAL_1,
                           trim(upper(ROL_HORINZONTAL_2)) ROL_HORINZONTAL_2,
                           trim(upper(ROL_HORINZONTAL_3)) ROL_HORINZONTAL_3,
                           trim(upper(ROL_HORINZONTAL_4)) ROL_HORINZONTAL_4,
                           trim(upper(ROL_HORINZONTAL_5)) ROL_HORINZONTAL_5,
                           trim(upper(ROL_HORINZONTAL_6)) ROL_HORINZONTAL_6,
                           trim(upper(ROL_HORINZONTAL_7)) ROL_HORINZONTAL_7,
                           trim(upper(ROL_HORINZONTAL_8)) ROL_HORINZONTAL_8,
                           trim(upper(ROL_HORINZONTAL_9)) ROL_HORINZONTAL_9,
                           trim(upper(ROL_HORINZONTAL_10)) ROL_HORINZONTAL_10
                      from gg_admin.SND_USER_TEMP
                      where trim(upper(nombre)) = trim(upper(x.nombre))
                       and trim(upper(apellido)) = trim(upper(x.apellido))

                     ) loop

                          begin

                           usuario_v_rol:= nvl(x.user_id , usuario_v);

                           if (y.rol_horinzontal_1 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_1,null);
                           end if;

                           if (y.rol_horinzontal_2 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_2,null);
                           end if;

                           if (y.rol_horinzontal_3 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_3,null);
                           end if;

                           if (y.rol_horinzontal_4 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_4,null);
                           end if;

                           if (y.rol_horinzontal_5 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_5,null);
                           end if;

                           if (y.rol_horinzontal_6 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_6,null);
                           end if;

                           if (y.rol_horinzontal_7 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_7,null);
                           end if;

                           if (y.rol_horinzontal_8 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_8,null);
                           end if;

                           if (y.rol_horinzontal_9 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_9,null);
                           end if;

                           if (y.rol_horinzontal_10 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_10,null);
                           end if;

                          end;
          end loop;

      exception
        when others then
          DBMS_OUTPUT.PUT_LINE('error' || sqlerrm || '::::::' ||
                               dbms_utility.format_error_backtrace);
      END;
      
      
      
      
      end if;
     
    if es_el_mismo = 1  then  
    for y in (
                    select trim(upper(ROL_HORINZONTAL_1)) ROL_HORINZONTAL_1,
                           trim(upper(ROL_HORINZONTAL_2)) ROL_HORINZONTAL_2,
                           trim(upper(ROL_HORINZONTAL_3)) ROL_HORINZONTAL_3,
                           trim(upper(ROL_HORINZONTAL_4)) ROL_HORINZONTAL_4,
                           trim(upper(ROL_HORINZONTAL_5)) ROL_HORINZONTAL_5,
                           trim(upper(ROL_HORINZONTAL_6)) ROL_HORINZONTAL_6,
                           trim(upper(ROL_HORINZONTAL_7)) ROL_HORINZONTAL_7,
                           trim(upper(ROL_HORINZONTAL_8)) ROL_HORINZONTAL_8,
                           trim(upper(ROL_HORINZONTAL_9)) ROL_HORINZONTAL_9,
                           trim(upper(ROL_HORINZONTAL_10)) ROL_HORINZONTAL_10
                      from gg_admin.SND_USER_TEMP
                      where trim(upper(nombre)) = trim(upper(x.nombre))
                       and trim(upper(apellido)) = trim(upper(x.apellido))

                     ) loop

                          begin

                           usuario_v_rol:= v_user_id_2do;

                           if (y.rol_horinzontal_1 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_1,null);
                           end if;

                           if (y.rol_horinzontal_2 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_2,null);
                           end if;

                           if (y.rol_horinzontal_3 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_3,null);
                           end if;

                           if (y.rol_horinzontal_4 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_4,null);
                           end if;

                           if (y.rol_horinzontal_5 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_5,null);
                           end if;

                           if (y.rol_horinzontal_6 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_6,null);
                           end if;

                           if (y.rol_horinzontal_7 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_7,null);
                           end if;

                           if (y.rol_horinzontal_8 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_8,null);
                           end if;

                           if (y.rol_horinzontal_9 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_9,null);
                           end if;

                           if (y.rol_horinzontal_10 is not null) then
                           p_relation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_10,null);
                           end if;

                          end;
          end loop; 
       end if;
       
       
    end loop;

  end loop;
 delete from gg_admin.SND_USER_TEMP;
 commit;

end;


procedure p_maxive_update_user_rol_horizontal
  is
    usuario_v   varchar2(200);
    REG_DESPUES number;
    contador    NUMBER := 1;
    verified number;
    v_user_id varchar2(200);
    v_user_id_2do varchar2(200);
    user_exist number;
    es_el_mismo number:=0;
    usuario_v_rol varchar2(200);
    correo_armado varchar2(200);
begin

    for x in (select distinct trim(upper(user_id)) user_id,
                              trim(upper(nombre))   nombre,
                              trim(upper(apellido)) apellido,
                              trim(upper(email))  email,
                              trim(upper(celular)) celular,
                              trim(upper(global_logon))   global_logon,
                              trim(upper(user_category))  user_category,
                              trim(upper(rol_horinzontal_1))  rol_horinzontal_1,
                              trim(upper(rol_horinzontal_2)) rol_horinzontal_2,
                              trim(upper(rol_horinzontal_3))  rol_horinzontal_3,
                              trim(upper(rol_horinzontal_4)) rol_horinzontal_4 ,
                              trim(upper(rol_horinzontal_5))  rol_horinzontal_5,
                              trim(upper(rol_horinzontal_6))  rol_horinzontal_6,
                              trim(upper(rol_horinzontal_7))  rol_horinzontal_7,
                              trim(upper(rol_horinzontal_8))  rol_horinzontal_8,
                              trim(upper(rol_horinzontal_9)) rol_horinzontal_9 ,
                              trim(upper(rol_horinzontal_10)) rol_horinzontal_10
                from gg_admin.SND_USER_TEMP
               order by nombre desc) loop



      begin
        begin

        update IPACS.SND_USER_LOGIN_DETAIL@DBLNK545
         set  user_desc = nvl(x.nombre || x.apellido,user_desc),
            user_last_name = nvl(x.apellido,user_last_name),
           user_name = nvl(x.nombre,user_name)
           where user_id = x.user_id;


        update ipacs.snd_user_detail@DBLNK545
        set  user_contact_no = nvl(x.celular,user_contact_no),
             user_email_id = nvl(x.email,user_contact_no),
             staff = nvl(x.global_logon,user_contact_no),
             user_category = nvl(x.user_category,user_contact_no),
             first_name = nvl(x.nombre,user_contact_no),
             last_name = nvl(x.apellido,user_contact_no)
        where user_id = x.user_id;


           dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido ||', fue actualizado'||','||x.email||chr(9));
           insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido,' fue actualizado', x.email);
           exception
             when others then
               dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v) ||'-'||x.nombre ||' '||x.apellido ||', error al actualizar verifique datos'||chr(9));
               insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido,' error al actualizar verifique datos', x.email);
             end;

           for y in (
                    select trim(upper(ROL_HORINZONTAL_1)) ROL_HORINZONTAL_1,
                           trim(upper(ROL_HORINZONTAL_2)) ROL_HORINZONTAL_2,
                           trim(upper(ROL_HORINZONTAL_3)) ROL_HORINZONTAL_3,
                           trim(upper(ROL_HORINZONTAL_4)) ROL_HORINZONTAL_4,
                           trim(upper(ROL_HORINZONTAL_5)) ROL_HORINZONTAL_5,
                           trim(upper(ROL_HORINZONTAL_6)) ROL_HORINZONTAL_6,
                           trim(upper(ROL_HORINZONTAL_7)) ROL_HORINZONTAL_7,
                           trim(upper(ROL_HORINZONTAL_8)) ROL_HORINZONTAL_8,
                           trim(upper(ROL_HORINZONTAL_9)) ROL_HORINZONTAL_9,
                           trim(upper(ROL_HORINZONTAL_10)) ROL_HORINZONTAL_10
                      from gg_admin.SND_USER_TEMP
                      where trim(upper(user_id)) = trim(upper(x.user_id))


                     ) loop

                          begin

                           usuario_v_rol:= x.user_id ;

                           if (y.rol_horinzontal_1 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_1,null);
                           end if;

                           if (y.rol_horinzontal_2 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_2,null);
                           end if;

                           if (y.rol_horinzontal_3 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_3,null);
                           end if;

                           if (y.rol_horinzontal_4 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_4,null);
                           end if;

                           if (y.rol_horinzontal_5 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_5,null);
                           end if;

                           if (y.rol_horinzontal_6 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_6,null);
                           end if;

                           if (y.rol_horinzontal_7 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_7,null);
                           end if;

                           if (y.rol_horinzontal_8 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_8,null);
                           end if;

                           if (y.rol_horinzontal_9 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_9,null);
                           end if;

                           if (y.rol_horinzontal_10 is not null) then
                           p_unrelation_user_role(nvl(x.user_id , usuario_v_rol),y.rol_horinzontal_10,null);
                           end if;

                          end;
          end loop;

      exception
        when others then
          DBMS_OUTPUT.PUT_LINE('error' || sqlerrm || '::::::' ||
                               dbms_utility.format_error_backtrace);
      END;


    end loop;


 delete from gg_admin.SND_USER_TEMP;
 commit;

end;

procedure p_maxive_unable_user_rol_horizontal
  is
    usuario_v   varchar2(200);
    REG_DESPUES number;
    contador    NUMBER := 1;
    verified number;
    v_user_id varchar2(200);
    v_user_id_2do varchar2(200);
    user_exist number;
    es_el_mismo number:=0;
    usuario_v_rol varchar2(200);
    correo_armado varchar2(200);
begin

    for x in (select distinct upper(trim(nombre)) nombre,
                              upper(trim(apellido)) apellido,
                              upper(trim(user_id)) user_id,
                              upper(trim(email)) email,
                              upper(trim(user_category)) user_category
                from gg_admin.SND_USER_TEMP
               order by nombre desc) loop


update ipacs.snd_user_login_detail@DBLNK545
set enabled  = 0
where user_id = x.user_id;
dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v) ||'-'||x.nombre ||' '||x.apellido ||', Fue desactivado'||','||x.email||chr(9));
               insert into gg_admin.SND_USER_TEMP_out values ('El usuario: ',nvl(x.user_id , usuario_v)||'-'||x.nombre ||' '||x.apellido,' Fue desactivado', x.email);

end loop;


 delete from gg_admin.SND_USER_TEMP;
 commit;
      exception
        when others then
          DBMS_OUTPUT.PUT_LINE('error' || sqlerrm || '::::::' ||
                               dbms_utility.format_error_backtrace);


end;
end pkg_manage_user_ipacs;
