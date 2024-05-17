PGDMP  ;                    |           StepWiseServer    16.2    16.2 I    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398    StepWiseServer    DATABASE     r   CREATE DATABASE "StepWiseServer" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
     DROP DATABASE "StepWiseServer";
                postgres    false                        3079    24824 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            �           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    2            �            1259    16463    User    TABLE     �   CREATE TABLE public."User" (
    user_id uuid NOT NULL,
    firstname character varying(25),
    lastname character varying(25),
    email character varying(255),
    creator boolean,
    password_hash text,
    session_key character varying(255)
);
    DROP TABLE public."User";
       public         heap    postgres    false            �            1259    16612    favouritelist    TABLE     �   CREATE TABLE public.favouritelist (
    fav_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    date_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
 !   DROP TABLE public.favouritelist;
       public         heap    postgres    false    2            �            1259    16482    material    TABLE     �   CREATE TABLE public.material (
    material_id uuid NOT NULL,
    tutorial_id uuid,
    mat_title character varying(50),
    mat_amount integer,
    mat_price double precision,
    link character varying(300)
);
    DROP TABLE public.material;
       public         heap    postgres    false            �            1259    16549    picturecontent    TABLE     �   CREATE TABLE public.picturecontent (
    id uuid NOT NULL,
    content_picture_link character varying(500),
    content_id uuid
);
 "   DROP TABLE public.picturecontent;
       public         heap    postgres    false            �            1259    16627    search_history    TABLE        CREATE TABLE public.search_history (
    search_id uuid NOT NULL,
    user_id uuid,
    searched_text character varying(40)
);
 "   DROP TABLE public.search_history;
       public         heap    postgres    false            �            1259    16517    steps    TABLE     p   CREATE TABLE public.steps (
    step_id uuid NOT NULL,
    tutorial_id uuid,
    title character varying(30)
);
    DROP TABLE public.steps;
       public         heap    postgres    false            �            1259    16502    substeps    TABLE     p   CREATE TABLE public.substeps (
    sub_step_id uuid NOT NULL,
    content_type smallint,
    content_id uuid
);
    DROP TABLE public.substeps;
       public         heap    postgres    false            �            1259    16527    substepslist    TABLE     q   CREATE TABLE public.substepslist (
    sub_step_list_id uuid NOT NULL,
    sub_step_id uuid,
    step_id uuid
);
     DROP TABLE public.substepslist;
       public         heap    postgres    false            �            1259    16542    textcontent    TABLE     y   CREATE TABLE public.textcontent (
    id uuid NOT NULL,
    content_text character varying(2042),
    content_id uuid
);
    DROP TABLE public.textcontent;
       public         heap    postgres    false            �            1259    16492    tools    TABLE     �   CREATE TABLE public.tools (
    tool_id uuid NOT NULL,
    tutorial_id uuid,
    tool_title character varying(50),
    tool_amount integer,
    link character varying(300),
    tool_price double precision
);
    DROP TABLE public.tools;
       public         heap    postgres    false            �            1259    16595    tutorialrating    TABLE     �   CREATE TABLE public.tutorialrating (
    rating_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    text character varying(2042),
    rating smallint
);
 "   DROP TABLE public.tutorialrating;
       public         heap    postgres    false            �            1259    16470 	   tutorials    TABLE     �  CREATE TABLE public.tutorials (
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
       public         heap    postgres    false            �            1259    16507    tutorialsearchlinks    TABLE     �   CREATE TABLE public.tutorialsearchlinks (
    search_link_id uuid NOT NULL,
    tutorial_id uuid,
    name_link character varying(30)
);
 '   DROP TABLE public.tutorialsearchlinks;
       public         heap    postgres    false            �            1259    16563    usercomments    TABLE     �   CREATE TABLE public.usercomments (
    comment_id uuid NOT NULL,
    step_id uuid,
    user_id uuid,
    text character varying(2042)
);
     DROP TABLE public.usercomments;
       public         heap    postgres    false            �            1259    16556    videocontent    TABLE        CREATE TABLE public.videocontent (
    id uuid NOT NULL,
    content_video_link character varying(500),
    content_id uuid
);
     DROP TABLE public.videocontent;
       public         heap    postgres    false            �            1259    16580    watch_history    TABLE     �   CREATE TABLE public.watch_history (
    history_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    last_watched_time timestamp with time zone,
    completed_steps smallint
);
 !   DROP TABLE public.watch_history;
       public         heap    postgres    false    2            ~          0    16463    User 
   TABLE DATA           j   COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM stdin;
    public          postgres    false    216    ]       �          0    16612    favouritelist 
   TABLE DATA           P   COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM stdin;
    public          postgres    false    230   �^       �          0    16482    material 
   TABLE DATA           d   COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM stdin;
    public          postgres    false    218   U_       �          0    16549    picturecontent 
   TABLE DATA           N   COPY public.picturecontent (id, content_picture_link, content_id) FROM stdin;
    public          postgres    false    225   "`       �          0    16627    search_history 
   TABLE DATA           K   COPY public.search_history (search_id, user_id, searched_text) FROM stdin;
    public          postgres    false    231   �a       �          0    16517    steps 
   TABLE DATA           <   COPY public.steps (step_id, tutorial_id, title) FROM stdin;
    public          postgres    false    222    b       �          0    16502    substeps 
   TABLE DATA           I   COPY public.substeps (sub_step_id, content_type, content_id) FROM stdin;
    public          postgres    false    220   �b       �          0    16527    substepslist 
   TABLE DATA           N   COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM stdin;
    public          postgres    false    223   �d       �          0    16542    textcontent 
   TABLE DATA           C   COPY public.textcontent (id, content_text, content_id) FROM stdin;
    public          postgres    false    224   �f       �          0    16492    tools 
   TABLE DATA           `   COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, link, tool_price) FROM stdin;
    public          postgres    false    219   �g       �          0    16595    tutorialrating 
   TABLE DATA           W   COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM stdin;
    public          postgres    false    229   �h                 0    16470 	   tutorials 
   TABLE DATA           �   COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM stdin;
    public          postgres    false    217   Di       �          0    16507    tutorialsearchlinks 
   TABLE DATA           U   COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM stdin;
    public          postgres    false    221   'j       �          0    16563    usercomments 
   TABLE DATA           J   COPY public.usercomments (comment_id, step_id, user_id, text) FROM stdin;
    public          postgres    false    227   Dj       �          0    16556    videocontent 
   TABLE DATA           J   COPY public.videocontent (id, content_video_link, content_id) FROM stdin;
    public          postgres    false    226   *k       �          0    16580    watch_history 
   TABLE DATA           m   COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM stdin;
    public          postgres    false    228   �k       �           2606    16469    User User_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);
 <   ALTER TABLE ONLY public."User" DROP CONSTRAINT "User_pkey";
       public            postgres    false    216            �           2606    16616     favouritelist favouritelist_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_pkey PRIMARY KEY (fav_id);
 J   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_pkey;
       public            postgres    false    230            �           2606    16486    material material_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);
 @   ALTER TABLE ONLY public.material DROP CONSTRAINT material_pkey;
       public            postgres    false    218            �           2606    16555 "   picturecontent picturecontent_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_pkey;
       public            postgres    false    225            �           2606    16631 "   search_history search_history_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (search_id);
 L   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_pkey;
       public            postgres    false    231            �           2606    16521    steps steps_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (step_id);
 :   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_pkey;
       public            postgres    false    222            �           2606    16506    substeps substeps_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.substeps
    ADD CONSTRAINT substeps_pkey PRIMARY KEY (sub_step_id);
 @   ALTER TABLE ONLY public.substeps DROP CONSTRAINT substeps_pkey;
       public            postgres    false    220            �           2606    16531    substepslist substepslist_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_pkey PRIMARY KEY (sub_step_list_id);
 H   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_pkey;
       public            postgres    false    223            �           2606    16548    textcontent textcontent_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_pkey;
       public            postgres    false    224            �           2606    16496    tools tools_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);
 :   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_pkey;
       public            postgres    false    219            �           2606    16601 "   tutorialrating tutorialrating_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_pkey PRIMARY KEY (rating_id);
 L   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_pkey;
       public            postgres    false    229            �           2606    16476    tutorials tutorials_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (tutorial_id);
 B   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_pkey;
       public            postgres    false    217            �           2606    16511 ,   tutorialsearchlinks tutorialsearchlinks_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_pkey PRIMARY KEY (search_link_id);
 V   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_pkey;
       public            postgres    false    221            �           2606    16569    usercomments usercomments_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_pkey PRIMARY KEY (comment_id);
 H   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_pkey;
       public            postgres    false    227            �           2606    16562    videocontent videocontent_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_pkey;
       public            postgres    false    226            �           2606    16584     watch_history watch_history_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_pkey PRIMARY KEY (history_id);
 J   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_pkey;
       public            postgres    false    228            �           2606    16617 ,   favouritelist favouritelist_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_tutorial_id_fkey;
       public          postgres    false    230    3519    217            �           2606    16622 (   favouritelist favouritelist_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.favouritelist DROP CONSTRAINT favouritelist_user_id_fkey;
       public          postgres    false    230    3517    216            �           2606    16487 "   material material_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 L   ALTER TABLE ONLY public.material DROP CONSTRAINT material_tutorial_id_fkey;
       public          postgres    false    217    218    3519            �           2606    16652 -   picturecontent picturecontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.picturecontent DROP CONSTRAINT picturecontent_content_id_fkey;
       public          postgres    false    3525    220    225            �           2606    16632 *   search_history search_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.search_history DROP CONSTRAINT search_history_user_id_fkey;
       public          postgres    false    216    3517    231            �           2606    16522    steps steps_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.steps DROP CONSTRAINT steps_tutorial_id_fkey;
       public          postgres    false    222    217    3519            �           2606    24872 &   substepslist substepslist_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_step_id_fkey;
       public          postgres    false    222    223    3529            �           2606    16532 *   substepslist substepslist_sub_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_sub_step_id_fkey FOREIGN KEY (sub_step_id) REFERENCES public.substeps(sub_step_id);
 T   ALTER TABLE ONLY public.substepslist DROP CONSTRAINT substepslist_sub_step_id_fkey;
       public          postgres    false    220    3525    223            �           2606    16657 '   textcontent textcontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.textcontent DROP CONSTRAINT textcontent_content_id_fkey;
       public          postgres    false    3525    224    220            �           2606    16497    tools tools_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 F   ALTER TABLE ONLY public.tools DROP CONSTRAINT tools_tutorial_id_fkey;
       public          postgres    false    217    3519    219            �           2606    16602 .   tutorialrating tutorialrating_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 X   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_tutorial_id_fkey;
       public          postgres    false    3519    217    229            �           2606    16607 *   tutorialrating tutorialrating_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 T   ALTER TABLE ONLY public.tutorialrating DROP CONSTRAINT tutorialrating_user_id_fkey;
       public          postgres    false    229    3517    216            �           2606    16477     tutorials tutorials_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 J   ALTER TABLE ONLY public.tutorials DROP CONSTRAINT tutorials_user_id_fkey;
       public          postgres    false    216    3517    217            �           2606    16512 8   tutorialsearchlinks tutorialsearchlinks_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 b   ALTER TABLE ONLY public.tutorialsearchlinks DROP CONSTRAINT tutorialsearchlinks_tutorial_id_fkey;
       public          postgres    false    3519    221    217            �           2606    16570 &   usercomments usercomments_step_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_step_id_fkey;
       public          postgres    false    222    3529    227            �           2606    16575 &   usercomments usercomments_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 P   ALTER TABLE ONLY public.usercomments DROP CONSTRAINT usercomments_user_id_fkey;
       public          postgres    false    3517    216    227            �           2606    16662 )   videocontent videocontent_content_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.videocontent DROP CONSTRAINT videocontent_content_id_fkey;
       public          postgres    false    226    220    3525            �           2606    16585 ,   watch_history watch_history_tutorial_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);
 V   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_tutorial_id_fkey;
       public          postgres    false    3519    217    228            �           2606    16590 (   watch_history watch_history_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);
 R   ALTER TABLE ONLY public.watch_history DROP CONSTRAINT watch_history_user_id_fkey;
       public          postgres    false    3517    216    228            ~   �  x���?�0���st�)�'��IE�H�b;�ʉ��-j�ۓ[@��H���g�h)S�V�x�=�٧H	J
!��a�w�sO�yc7��۝v��|>_���f���潹��o��{��_��8��iQP�|ʚ���^Z����6vu��vr;_^��zz>^V�U]�rs��>~�����/}Y�U䒓X����nSj�<x�f��z�P�HC�;5+�
X��Ejȱ�.eT�Hbb�.p
Ղ�d��U���Z��$H��b3L}y��-U���f���X�|�l���s�W����C޽�o��C���n�?��Ti "2���9Ac�ص�QFQ
���̝�JU�E
$�P�	��� C�+�ԛ���.y����`u��4��d1��)���3�!�X<�-�_��	      �   �   x����m�0�R�������X�#�d�!X���(���7=q���1�ծ�z����/FK�^j�q=ZkJM��$9L��ˏ���z1�4EO�-����M����;@
�ζ6��?~�[�X�bW�W�Z�>udY�g�/1��y��@      �   �   x���Aj1��}�\@3�,��ޡ7�F�eZȐf��7�.��|���kV+vtP��$A%#h����YQqr�[�̀x$���m#�"����Ǘ^/t��G�@��>��������~����u�-)��f֍A���	�����1�?u��)������瀜���ؔ
�9Kȵz�s<��R('p�K��_�f�      �   d  x���͎�!Eדwqblc`�O0�M�Q�Q*���,�.3�y��΅{`�Tm}L(��kR-R� �˷���z��{������~�~_��Q�?�__޾�:�4"�Edch�N�Z�:8��\��1ab��;u`�p�:�=������*�Ud5�>���W��ѽ���O�a}����i8zpД����~V��
�5H���)�ΘS^"�z������
9B��`�窻���������PM���auS_���k���0��Ӳ%\�J����Z�qD!Җ°^2�t�ǽֺ��Qd?1��e֝;���̠3���\?���}ϴ �ǖ��s{O�\�F;��Χ��/#+      �   z   x��̽1@�:���N��,� 4ɝ��а=�͓��u�5hn|�[ ��sb�p$*5X� ���W见�*1#b�}?�u䎣�8�`W��*"5�$cK����u���x��%��G),      �      x���A
�0���
��Z)�����KB]RB���l
�G�vXV U�4���o	�}EJ�<i�ٱ��8�ϳ�l��Ƕ���3�->Z4�l_��%����ͨ�ci�)�/���k ��C�t      �   �  x���˱�0D��\�%!�'��	��1xvvU��F�+i�@�L�����y�?��2~�]Dͺ�2}�]��u�e���h7+�e����'��~a�?�.��=�͵a���gf`�A�n�m��3��{_�����	�!�S�P�r����7��d��6\�|�Oڝ�gGH���dYÑ�1Mu	�~��բA�e���9�=��A'�O��e[{Wg�y���%��	�s��RHGmʡ^�,����j�
��:`���u�[s=�ұn6/��L�*��:�u�YK��@�@�F��k�Z;Hļ�����@��e���A�BǎN�_��s�t^�
�G��Y]�=T������[�-�&K&���ڥ����v�݄�<� lx��W]��1�CEk�Jnl�sIw�=:�:[f�qo�ڡ�؂�e�K>����y����#�      �   k  x��UA�� [w���) �]����9�t�J�$!���V�������$;*�}�z&K�I�|S�
<��YGm��Y��g]d�^R=�VI̫��f���p�.9V�^4��;:�`���/����o8}�7�2ϱ����t���Be��><Z����3~��a�$�7iO#U���dà#������TP�t�Y���� ���$c���wp��ڕC ���	��_Zs^�r�������X�cZ��"�2%�]�L<����{����J1hD�p�6�Q��Up?���|�0)8@�7Z3�.c����E(�ݠdl�F*�����8��'��n�9���P]턝����$��u:A���-��³�+]}>�VĞ�F��-��h��5ʎU{�*\v�"c�T��/DƩ�c��Y2;�H ��;�y����j+������ٰ��"N���,����{���9��I'��gO�I��1I{��ƭ�r��5V�x���	�Y��|��Vf�W;��;8�6�#"G>�.)�v�s�!����/\���:���6�t�xI���D&�\0<~Z¨�C�6$� 0����� �i��c�	������|�����      �   �   x����n�0@��+�T6���]��[���Jե��I��6Q��J: �ǣ ��AS.��Wctޱ�.Ng��.ס�a�r3�G9}7�,ݜc��ʛq��e��@��?�m���
�}`>j����nm��~O����BA�jJ	�����b��b���|o�o�1�؁�����8�U��6/�n�����i��O|쭻      �   �   x���Mj1�}���2�l�vϑe7��ia�C�@�_�KC�R�x�*�H�{Q��
��K�SCC�5�DД+ ue�H���7�9��1��y��g962h>������Un�C/m��sE�A��e���e�L��IWԔ��l�o�~��5�^�]��,-��耬�!�!D�gt�8���N������ �fJ      �   �   x���;
1 ������O~�K��M�,���_+��14c1��d�Z��̹��n�xJ�fm��~�rF�"1�)��>��-�`�.�綯z�/�X�������ń���qo��7�����!'�z�޿u*EU         �   x��ϱV� �z��� 	C�j���6$�d�d�a��+m<ZX�ｋh�l?Hv~�g#C�%a�k�)e��QR�ak�Rz������l�'�%9oe��0�q�8���@x����Qb�5K�ͷ�k)ǩ�4����T���Syd�88�J{9���s�E�l���ڷc��V�����_ ������(��&���Ui����V���w.      �      x������ � �      �   �   x���;NAD��S����/����-!�Z��7!@Z�ْ�zz%͐4bi�4�SE��լ�&9,6S"Yʕ}�2wR� *Q��"�G�<���c��O�}�q���__��*np��(*��&u%�� 
Ko�#���|�>�>D)�2����6�0��E����QV��D��ZC`Jbz�դZ���OÄ���nkp/ι/穕u      �   �   x���A��0@�5��iHl�����c;�Q����O���z&��v6G@��m�����;�qy����������~�;������,JG#��8)`�&J��P:��狗�c�[�^�H*�F�@���2�G���[�	ٴ���tV�k��r�h��&6䣵#��z��.��+�D      �   �   x����!C�PE���#0l-�� ��:�%��TG��fe��Z�@���Tm�T��z��4G�V�8��H������%����/8�����e�-�I�"�o�Em��5v�$�K���K�B�4�^h��O	����p��ϕs� @�     