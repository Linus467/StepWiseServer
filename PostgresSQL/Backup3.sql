PGDMP      '    
    	        |           StepWiseServer_test    16.2    16.1 G    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16667    StepWiseServer_test    DATABASE     w   CREATE DATABASE "StepWiseServer_test" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
 %   DROP DATABASE "StepWiseServer_test";
                postgres    false            �            1259    16668    User    TABLE     �   CREATE TABLE public."User" (
    user_id uuid NOT NULL,
    firstname character varying(25),
    lastname character varying(25),
    email character varying(255),
    creator boolean,
    password_hash text,
    session_key character varying(255)
);
    DROP TABLE public."User";
       public         heap    postgres    false            �            1259    16817    favouritelist    TABLE     �   CREATE TABLE public.favouritelist (
    fav_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    date_time timestamp with time zone
);
 !   DROP TABLE public.favouritelist;
       public         heap    postgres    false            �            1259    16687    material    TABLE     �   CREATE TABLE public.material (
    material_id uuid NOT NULL,
    tutorial_id uuid,
    mat_title character varying(20),
    mat_amount integer,
    mat_price double precision,
    link character varying(300)
);
    DROP TABLE public.material;
       public         heap    postgres    false            �            1259    16754    picturecontent    TABLE     �   CREATE TABLE public.picturecontent (
    id uuid NOT NULL,
    content_picture_link character varying(500),
    content_id uuid
);
 "   DROP TABLE public.picturecontent;
       public         heap    postgres    false            �            1259    16832    search_history    TABLE        CREATE TABLE public.search_history (
    search_id uuid NOT NULL,
    user_id uuid,
    searched_text character varying(40)
);
 "   DROP TABLE public.search_history;
       public         heap    postgres    false            �            1259    16722    steps    TABLE     p   CREATE TABLE public.steps (
    step_id uuid NOT NULL,
    tutorial_id uuid,
    title character varying(30)
);
    DROP TABLE public.steps;
       public         heap    postgres    false            �            1259    16707    substeps    TABLE     p   CREATE TABLE public.substeps (
    sub_step_id uuid NOT NULL,
    content_type smallint,
    content_id uuid
);
    DROP TABLE public.substeps;
       public         heap    postgres    false            �            1259    16732    substepslist    TABLE     q   CREATE TABLE public.substepslist (
    sub_step_list_id uuid NOT NULL,
    sub_step_id uuid,
    step_id uuid
);
     DROP TABLE public.substepslist;
       public         heap    postgres    false            �            1259    16747    textcontent    TABLE     y   CREATE TABLE public.textcontent (
    id uuid NOT NULL,
    content_text character varying(2042),
    content_id uuid
);
    DROP TABLE public.textcontent;
       public         heap    postgres    false            �            1259    16697    tools    TABLE     �   CREATE TABLE public.tools (
    tool_id uuid NOT NULL,
    tutorial_id uuid,
    tool_title character varying(20),
    tool_amount integer,
    tool_price double precision,
    link character varying(300)
);
    DROP TABLE public.tools;
       public         heap    postgres    false            �            1259    16800    tutorialrating    TABLE     �   CREATE TABLE public.tutorialrating (
    rating_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    text character varying(2042),
    rating smallint
);
 "   DROP TABLE public.tutorialrating;
       public         heap    postgres    false            �            1259    16675 	   tutorials    TABLE     �  CREATE TABLE public.tutorials (
    tutorial_id uuid NOT NULL,
    title character varying(30),
    tutorial_kind character varying(30),
    user_id uuid,
    "time" smallint,
    difficulty smallint,
    complete boolean,
    description character varying(2042),
    preview_picture_link character varying(500),
    preview_type character varying(20),
    views smallint,
    steps smallint
);
    DROP TABLE public.tutorials;
       public         heap    postgres    false            �            1259    16712    tutorialsearchlinks    TABLE     �   CREATE TABLE public.tutorialsearchlinks (
    search_link_id uuid NOT NULL,
    tutorial_id uuid,
    name_link character varying(30)
);
 '   DROP TABLE public.tutorialsearchlinks;
       public         heap    postgres    false            �            1259    16768    usercomments    TABLE     �   CREATE TABLE public.usercomments (
    comment_id uuid NOT NULL,
    step_id uuid,
    user_id uuid,
    text character varying(2042)
);
     DROP TABLE public.usercomments;
       public         heap    postgres    false            �            1259    16761    videocontent    TABLE        CREATE TABLE public.videocontent (
    id uuid NOT NULL,
    content_video_link character varying(500),
    content_id uuid
);
     DROP TABLE public.videocontent;
       public         heap    postgres    false            �            1259    16785    watch_history    TABLE     �   CREATE TABLE public.watch_history (
    history_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    last_watched_time timestamp with time zone,
    completed_steps smallint
);
 !   DROP TABLE public.watch_history;
       public         heap    postgres    false            p          0    16668    User 
   TABLE DATA           j   COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM stdin;
    public          postgres    false    215   �Z       ~          0    16817    favouritelist 
   TABLE DATA           P   COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM stdin;
    public          postgres    false    229   �[       r          0    16687    material 
   TABLE DATA           d   COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM stdin;
    public          postgres    false    217   �[       y          0    16754    picturecontent 
   TABLE DATA           N   COPY public.picturecontent (id, content_picture_link, content_id) FROM stdin;
    public          postgres    false    224   �[                 0    16832    search_history 
   TABLE DATA           K   COPY public.search_history (search_id, user_id, searched_text) FROM stdin;
    public          postgres    false    230   �\       v          0    16722    steps 
   TABLE DATA           <   COPY public.steps (step_id, tutorial_id, title) FROM stdin;
    public          postgres    false    221   �\       t          0    16707    substeps 
   TABLE DATA           I   COPY public.substeps (sub_step_id, content_type, content_id) FROM stdin;
    public          postgres    false    219   (]       w          0    16732    substepslist 
   TABLE DATA           N   COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM stdin;
    public          postgres    false    222   �]       x          0    16747    textcontent 
   TABLE DATA           C   COPY public.textcontent (id, content_text, content_id) FROM stdin;
    public          postgres    false    223   >^       s          0    16697    tools 
   TABLE DATA           `   COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, tool_price, link) FROM stdin;
    public          postgres    false    218   �^       }          0    16800    tutorialrating 
   TABLE DATA           W   COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM stdin;
    public          postgres    false    228   �^       q          0    16675 	   tutorials 
   TABLE DATA           �   COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM stdin;
    public          postgres    false    216   _       u          0    16712    tutorialsearchlinks 
   TABLE DATA           U   COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM stdin;
    public          postgres    false    220   �_       {          0    16768    usercomments 
   TABLE DATA           J   COPY public.usercomments (comment_id, step_id, user_id, text) FROM stdin;
    public          postgres    false    226   �_       z          0    16761    videocontent 
   TABLE DATA           J   COPY public.videocontent (id, content_video_link, content_id) FROM stdin;
    public          postgres    false    225   �_       |          0    16785    watch_history 
   TABLE DATA           m   COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM stdin;
    public          postgres    false    227   �`       �           2606    16674    User User_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public            postgres    false    215            �           2606    16821     favouritelist favouritelist_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_pkey PRIMARY KEY (fav_id);
 J   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_pkey;
       public            postgres    false    229            �           2606    16691    material material_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);
 @   ALTER TABLE ONLY public.material DROP CONSTRAINT material_pkey;
       public            postgres    false    217            �           2606    16760 "   picturecontent picturecontent_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_pkey;
       public            postgres    false    224            �           2606    16836 "   search_history search_history_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (search_id);
 L   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_pkey;
       public            postgres    false    230            �           2606    16726    steps steps_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (step_id);
 :   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_pkey;
       public            postgres    false    221            �           2606    16711    substeps substeps_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.substeps
    ADD CONSTRAINT substeps_pkey PRIMARY KEY (sub_step_id);
 @   ALTER TABLE ONLY public.substeps DROP CONSTRAINT substeps_pkey;
       public            postgres    false    219            �           2606    16736    substepslist substepslist_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_pkey PRIMARY KEY (sub_step_list_id);
 H   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_pkey;
       public            postgres    false    222            �           2606    16753    textcontent textcontent_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_pkey;
       public            postgres    false    223            �           2606    16701    tools tools_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);
 :   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_pkey;
       public            postgres    false    218            �           2606    16806 "   tutorialrating tutorialrating_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_pkey PRIMARY KEY (rating_id);
 L   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_pkey;
       public            postgres    false    228            �           2606    16681    tutorials tutorials_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (tutorial_id);
 B   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_pkey;
       public            postgres    false    216            �           2606    16716 ,   tutorialsearchlinks tutorialsearchlinks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_pkey PRIMARY KEY (search_link_id);
 V   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_pkey;
       public            postgres    false    220            �           2606    16774    usercomments usercomments_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_pkey PRIMARY KEY (comment_id);
 H   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_pkey;
       public            postgres    false    226            �           2606    16767    videocontent videocontent_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_pkey;
       public            postgres    false    225            �           2606    16789     watch_history watch_history_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_pkey PRIMARY KEY (history_id);
 J   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_pkey;
       public            postgres    false    227            �           2606    16822 ,   favouritelist favouritelist_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_tutorial_id_fkey;
       public          postgres    false    216    229    3505            �           2606    16827 (   favouritelist favouritelist_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_user_id_fkey;
       public          postgres    false    3503    229    215            �           2606    16692 "   material material_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 L   ALTER TABLE ONLY public.material DROP CONSTRAINT material_tutorial_id_fkey;
       public          postgres    false    3505    217    216            �           2606    16842 -   picturecontent picturecontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_content_id_fkey;
       public          postgres    false    219    3511    224            �           2606    16837 *   search_history search_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_user_id_fkey;
       public          postgres    false    3503    230    215            �           2606    16727    steps steps_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_tutorial_id_fkey;
       public          postgres    false    221    3505    216            �           2606    16742 &   substepslist substepslist_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);
 P   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_step_id_fkey;
       public          postgres    false    3515    221    222            �           2606    16737 *   substepslist substepslist_sub_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_sub_step_id_fkey FOREIGN KEY (sub_step_id) REFERENCES public.substeps(sub_step_id);
 T   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_sub_step_id_fkey;
       public          postgres    false    222    219    3511            �           2606    16847 '   textcontent textcontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_content_id_fkey;
       public          postgres    false    3511    219    223            �           2606    16702    tools tools_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_tutorial_id_fkey;
       public          postgres    false    218    216    3505            �           2606    16807 .   tutorialrating tutorialrating_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 X   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_tutorial_id_fkey;
       public          postgres    false    216    3505    228            �           2606    16812 *   tutorialrating tutorialrating_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_user_id_fkey;
       public          postgres    false    3503    215    228            �           2606    16682     tutorials tutorials_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 J   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_user_id_fkey;
       public          postgres    false    216    3503    215            �           2606    16717 8   tutorialsearchlinks tutorialsearchlinks_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 b   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_tutorial_id_fkey;
       public          postgres    false    216    3505    220            �           2606    16775 &   usercomments usercomments_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_step_id_fkey;
       public          postgres    false    221    226    3515            �           2606    16780 &   usercomments usercomments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_user_id_fkey;
       public          postgres    false    215    226    3503            �           2606    16852 )   videocontent videocontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_content_id_fkey;
       public          postgres    false    225    3511    219            �           2606    16790 ,   watch_history watch_history_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_tutorial_id_fkey;
       public          postgres    false    216    3505    227            �           2606    16795 (   watch_history watch_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_user_id_fkey;
       public          postgres    false    215    3503    227            p   �   x���1�0����%\)-nN.�,�r
�6џoq0qrx�{��P֬m�g+P�����Z�B����nW�ns.~Q�.� �N1>�ǀ���V��BG+�=Li�9���|;D-�H�I8σPNA��m�V��Ֆ�.�I�Ӵ�2Dq�G�/��x��C&      ~      x������ � �      r      x������ � �      y   �   x�}�=�0@���@��qz���%	vԪ��R�_V���ϑ,�$0��e{�(bHq��t[��<�+��i}{�������B�X�����ܵ:�"s�LB�(S�ISu;ppw�3m� f(M�{���ҁC��TK30f�kP*Ȉ�m�r��ݙ����>|W5            x������ � �      v   m   x���A
� еs
/`8�u�Z�)2C����`h����w��M�� m�,o6L! cdk{�r��XӥQ��鮹˩X�?|j}/N�*�}��� �>���� s�^      t   S   x��ι�0ј��H�8��V�;�-Ǫ��'����6���I�+JB3g���BJ+g��#�_;g#G�~��u|��wC�      w   �   x����1г���3��\6������ь�F.8�7����D�;}�rp3�#:�� �Ͱ�Bc��Ƀ��:z��:�N��`�}6ĒR�x���9��K#����wV��(�x� �6�4�s�G��CY��"�Ut}nYm�9mz=���� >i/      x   y   x���=
�0@�ڜb.�c���FK�#b��ߟV$���x�
6�u���k�����ڐ�hЙڬ��V�U`
4�7�?@�Q�6�`�}Ր�3HwpL���C:AN�����r��߻]y      s      x������ � �      }      x������ � �      q   �   x���=� �z9E.@�.Z=���F���oҨM&[l�����U�^q�ޜ9�Er3�\Q]�����!9���d�wC��P��aoMr1�0mH�O�5縭*�2>��l���7���;���hyN~������@��3i�I��ةd����^�      u      x������ � �      {      x������ � �      z   �   x�u�1n�0 �9�m��H����H$��A��7�G�n�Έ���K���m�D�D����:��-�}?~s����D>q��ݿ��QaTj������EP�������������B�P(!6
+���RΥI�ޠ��E�C�Y�I�����.���Rg      |      x������ � �     