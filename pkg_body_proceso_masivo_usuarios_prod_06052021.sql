create or replace package body pkg_manage_user_ipacs is

  procedure p_insert_user(p_user_desc                 in NVARCHAR2,
                          p_user_password             in NVARCHAR2,
                          p_enabled                   in NUMBER,
                          p_add_by                    in NVARCHAR2,
                          p_add_date                  in DATE,
                          p_mod_by                    in NVARCHAR2,
                          p_mod_date                  in DATE,
                          p_last_passwrod_change_date in DATE,
                          p_default_password          in NVARCHAR2,
                          p_last_login_date           in DATE,
                          p_block_user_count          in NUMBER,
                          p_user_last_name            in VARCHAR2,
                          p_otp_flag                  in VARCHAR2,
                          p_firebase_token            in VARCHAR2,
                          p_user_name                 in VARCHAR2,
                          p_user_type_id              in NUMBER,
                          p_user_zone_id              in NUMBER,
                          p_user_hub_id               in NUMBER,
                          p_user_area_id              in NUMBER,
                          p_user_contact_no           in NVARCHAR2,
                          p_user_email_id             in NVARCHAR2,
                          p_user_address1             in VARCHAR2,
                          p_user_address2             in VARCHAR2,
                          p_user_address3             in VARCHAR2,
                          p_user_postal_code          in NVARCHAR2,
                          p_user_parent_id            in NVARCHAR2,
                          p_user_status               in NUMBER,
                          p_user_longitude            in NVARCHAR2,
                          p_user_latitude             in NVARCHAR2,
                          p_comments                  in NCLOB,
                          p_suspend_id                in NUMBER,
                          p_user_secondary_contact    in NVARCHAR2,
                          p_staff                     in NUMBER,
                          p_user_agency               in NVARCHAR2,
                          p_postal_code               in NVARCHAR2,
                          p_pin_no                    in NVARCHAR2,
                          p_vat_no                    in NVARCHAR2,
                          p_national_id               in NVARCHAR2,
                          p_start_date                in DATE,
                          p_end_date                  in DATE,
                          p_dept                      in NVARCHAR2,
                          p_activator_name            in VARCHAR2,
                          p_post                      in VARCHAR2,
                          p_owner_name                in VARCHAR2,
                          p_activation_code           in VARCHAR2,
                          p_user_category             in INTEGER,
                          p_dob                       in DATE,
                          p_user_loc_id               in FLOAT,
                          p_suspend_remarks           in VARCHAR2,
                          p_danger_zone               in VARCHAR2,
                          p_first_name                in VARCHAR2,
                          p_last_name                 in VARCHAR2,
                          p_observations              in VARCHAR2,
                          p_rubro                     in VARCHAR2) is
    usuario_v   varchar2(200);
    REG_DESPUES number;
    contador    NUMBER := 1;
    verified number;
    v_user_id varchar2(200);
    user_exist number;
  begin

    begin
    select user_id
      into v_user_id
      from (select user_id
              from ipacs.snd_user_detail
             where trim(upper(first_name)) = trim(upper(p_first_name))
               and trim(upper(last_name)) = trim(upper(p_last_name))
             order by start_date desc)
     where rownum = 1;

    user_exist:= 1;

    exception
      when others then

      usuario_v := substr(p_first_name, 1, 1) || p_last_name ||SUBSTR(v_user_id,- 1);
       verified := 1;
     end;

  if user_exist = 1 then
    begin
    usuario_v := substr(p_first_name, 1, 1) || p_last_name ||(SUBSTR(v_user_id,- 1)+1);
    exception
      when  others then
        usuario_v := substr(p_first_name, 1, 1) || p_last_name ||'1' ;
        end;
    verified := 1;
  end if;

  if verified = 1 then
    begin
      insert into IPACS.SND_USER_LOGIN_DETAIL
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
        (upper(usuario_v),
         p_user_desc,
         '',
         3,
         p_add_by,
         p_add_date,
         p_mod_by,
         p_mod_date,
         p_last_passwrod_change_date,
         p_default_password,
         p_last_login_date,
         p_block_user_count,
         p_user_last_name,
         p_otp_flag,
         p_firebase_token,
         p_user_name

         );

      insert into ipacs.snd_user_detail
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
        (upper(usuario_v),
         '-1',
         '0',
         '0',
         '0',
         p_user_contact_no,
         p_user_email_id,
         'MGR'||trunc(sysdate),
         p_user_address2,
         p_user_address3,
         p_user_postal_code,
         p_user_parent_id,
         '3',
         p_user_longitude,
         p_user_latitude,
         p_comments,
         p_suspend_id,
         p_user_secondary_contact,
         'DEEPAK',
         0,
         p_user_agency,
         p_postal_code,
         p_pin_no,
         p_vat_no,
         p_national_id,
         sysdate,
         TO_DATE('31/12/2099', 'DD/MM/YYYY'),
         p_dept,
         p_activator_name,
         p_post,
         p_owner_name,
         p_activation_code,
         '10',
         p_dob,
         '0',
         p_suspend_remarks,
         p_danger_zone,
         p_first_name,
         p_last_name,
         p_observations,
         p_rubro);
    exception
      when others then
           dbms_output.put_line(sqlerrm || dbms_utility.format_error_backtrace);

    end;
  end if;
  end;

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
        from ipacs.snd_user_roles
       where user_id = p_user_id
         and role = p_role;
         dbms_output.put_line('El usuario:, '||p_user_id ||', ya contaba con el Rol:,'||p_role||chr(9));
    exception
      when no_data_found then

        INSERT INTO ipacs.snd_user_roles
          (user_id, role, priority)
        VALUES
          (p_user_id, p_role, p_priority);
        dbms_output.put_line('El usuario:, '||p_user_id ||', se le agrego el Rol:,'||p_role||chr(9));
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

procedure p_maxive_insert_user_rol_vertical is
    usuario_v   varchar2(200);
    REG_DESPUES number;
    contador    NUMBER := 1;
    verified number;
    v_user_id varchar2(200);

    user_exist number;
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
              from IPACS.SND_USER_LOGIN_DETAIL a, ipacs.snd_user_detail b
             where a.user_id = b.user_id
               and a.user_id like 'DEEPAK') loop

    for x in (select distinct upper(trim(nombre)) nombre,
                              upper(trim(apellido)) apellido,
                              upper(trim(user_id)) user_id,
                              upper(trim(email)) email,
                              upper(trim(user_category)) user_category
                from SND_USER_TEMP
               order by nombre desc) loop


      begin
    select user_id
      into v_user_id
      from (select user_id
              from ipacs.snd_user_detail
             where trim(upper(first_name)) = trim(upper(x.nombre))
               and trim(upper(last_name)) = trim(upper(x.apellido))
             order by start_date desc)
     where rownum = 1;

    user_exist:= 1;

    exception
      when others then
      usuario_v := substr(x.nombre, 1, 1) || x.apellido ||SUBSTR(v_user_id,- 1);
      verified := 1;
     end;

  if user_exist = 1 then
    begin
    usuario_v := substr(x.nombre, 1, 1) || x.apellido ||(SUBSTR(v_user_id,- 1)+1);
    exception
      when  others then
        usuario_v := substr(x.nombre, 1, 1) || x.apellido ||'1' ;
        end;
    verified := 1;
  end if;

  if verified = 1 then

      begin
        insert into IPACS.SND_USER_LOGIN_DETAIL
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
           null,
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

        insert into ipacs.snd_user_detail
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
           trim(x.email),
           i.user_address1,
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

           for y in (select distinct upper(trim(rol)) rol
                      from SND_USER_TEMP
                      where trim(upper(nombre)) = trim(upper(x.nombre))
                       and trim(upper(apellido)) = trim(upper(x.apellido))
                     order by rol desc) loop
                          begin
                           p_relation_user_role(nvl(x.user_id , usuario_v),y.rol,null);
                          end;
          end loop;

      exception
        when others then
          DBMS_OUTPUT.PUT_LINE('error' || sqlerrm || '::::::' ||
                               dbms_utility.format_error_backtrace);
      END;
      end if;

    end loop;

  end loop;
end;


procedure p_maxive_insert_user_rol_horizontal
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
              from IPACS.SND_USER_LOGIN_DETAIL a, ipacs.snd_user_detail b
             where a.user_id = b.user_id
               and a.user_id like 'DEEPAK') loop

    for x in (select distinct upper(trim(nombre)) nombre,
                              upper(trim(apellido)) apellido,
                              upper(trim(user_id)) user_id,
                              upper(trim(email)) email,
                              upper(trim(user_category)) user_category,
                              upper(trim(staff)) staff,
                              upper(trim(provedor)) provedor,
                              upper(trim(encargado)) encargado
                from SND_USER_TEMP
               order by nombre desc) loop

      if (x.user_id is not null) and (x.email is null)  then
      correo_armado:= trim(upper(x.user_id))||upper('@att.com');
      end if;

      begin
    --valida si existe y si es el mismo
    select user_id
      into v_user_id
      from (select user_id
              from ipacs.snd_user_detail
             where trim(upper(first_name)) = trim(upper(x.nombre))
               and trim(upper(last_name)) = trim(upper(x.apellido))
             order by start_date desc)
     where rownum = 1;

     begin
         select user_id
          into v_user_id_2do
          from (select user_id
                  from ipacs.snd_user_detail
                 where trim(upper(first_name)) = trim(upper(x.nombre))
                   and trim(upper(last_name)) = trim(upper(x.apellido))
                   and trim(upper(user_email_id)) = trim(upper(x.email))
                 order by start_date desc)
         where rownum = 1;
         es_el_mismo := 1;
         dbms_output.put_line('El usuario:, '||v_user_id_2do ||'-'||x.nombre ||' '||x.apellido ||', ya existia'||','||x.email||chr(9));
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
        insert into IPACS.SND_USER_LOGIN_DETAIL
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
           x.encargado,
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

        insert into ipacs.snd_user_detail
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
           x.provedor,
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
           x.staff,
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
           x.encargado,
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
           exception
             when others then
               dbms_output.put_line('El usuario:, '||nvl(x.user_id , usuario_v) ||'-'||x.nombre ||' '||x.apellido ||', ya existia'||','||x.email||chr(9));
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
                      from SND_USER_TEMP
                      where trim(upper(nombre)) = trim(upper(x.nombre))
                       and trim(upper(apellido)) = trim(upper(x.apellido))
                     order by rol desc
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

    end loop;

  end loop;
end;

end pkg_manage_user_ipacs;
