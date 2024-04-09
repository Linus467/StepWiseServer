--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.1

-- Started on 2024-04-09 10:31:07 IST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16463)
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    user_id uuid NOT NULL,
    firstname character varying(25),
    lastname character varying(25),
    email character varying(255),
    creator boolean,
    password_hash text,
    session_key character varying(255)
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16612)
-- Name: favouritelist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favouritelist (
    fav_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    date_time timestamp with time zone
);


ALTER TABLE public.favouritelist OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16482)
-- Name: material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material (
    material_id uuid NOT NULL,
    tutorial_id uuid,
    mat_title character varying(50),
    mat_amount integer,
    mat_price double precision,
    link character varying(300)
);


ALTER TABLE public.material OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16549)
-- Name: picturecontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.picturecontent (
    id uuid NOT NULL,
    content_picture_link character varying(500),
    content_id uuid
);


ALTER TABLE public.picturecontent OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16627)
-- Name: search_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.search_history (
    search_id uuid NOT NULL,
    user_id uuid,
    searched_text character varying(40)
);


ALTER TABLE public.search_history OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16517)
-- Name: steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.steps (
    step_id uuid NOT NULL,
    tutorial_id uuid,
    title character varying(30)
);


ALTER TABLE public.steps OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16502)
-- Name: substeps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substeps (
    sub_step_id uuid NOT NULL,
    content_type smallint,
    content_id uuid
);


ALTER TABLE public.substeps OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16527)
-- Name: substepslist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.substepslist (
    sub_step_list_id uuid NOT NULL,
    sub_step_id uuid,
    step_id uuid
);


ALTER TABLE public.substepslist OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16542)
-- Name: textcontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.textcontent (
    id uuid NOT NULL,
    content_text character varying(2042),
    content_id uuid
);


ALTER TABLE public.textcontent OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16492)
-- Name: tools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools (
    tool_id uuid NOT NULL,
    tutorial_id uuid,
    tool_title character varying(50),
    tool_amount integer,
    link character varying(300),
    tool_price double precision
);


ALTER TABLE public.tools OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16595)
-- Name: tutorialrating; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorialrating (
    rating_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    text character varying(2042),
    rating smallint
);


ALTER TABLE public.tutorialrating OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16470)
-- Name: tutorials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorials (
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


ALTER TABLE public.tutorials OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16507)
-- Name: tutorialsearchlinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutorialsearchlinks (
    search_link_id uuid NOT NULL,
    tutorial_id uuid,
    name_link character varying(30)
);


ALTER TABLE public.tutorialsearchlinks OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16563)
-- Name: usercomments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usercomments (
    comment_id uuid NOT NULL,
    step_id uuid,
    user_id uuid,
    text character varying(2042)
);


ALTER TABLE public.usercomments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16556)
-- Name: videocontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.videocontent (
    id uuid NOT NULL,
    content_video_link character varying(500),
    content_id uuid
);


ALTER TABLE public.videocontent OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16580)
-- Name: watch_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watch_history (
    history_id uuid NOT NULL,
    tutorial_id uuid,
    user_id uuid,
    last_watched_time timestamp with time zone,
    completed_steps smallint
);


ALTER TABLE public.watch_history OWNER TO postgres;

--
-- TOC entry 3696 (class 0 OID 16463)
-- Dependencies: 215
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (user_id, firstname, lastname, email, creator, password_hash, session_key) FROM stdin;
123e4567-e89b-12d3-a456-426614174000	John	Doe	john@example.com	t	password123	\N
223e4567-e89b-12d3-a456-426614174001	Jane	Smith	jane@example.com	f	password456	\N
03275be5-9481-4895-ae9b-d1b7927d4812	New	User	newuser@example.com	f	scrypt:32768:8:1$H5mGnheIH8mDxxyq$96cc6f1333aa6cf2da419a3c2dc88f7f7c602a9be1d51aada2cb8ce87b71430d14b65d5013941355266b166a190cd8694d9bc70bd76cdb5ff493301cf062ffac	\N
df0aca4e-545a-4642-a4d0-4798b23a382e	New	User	test@example.com	f	scrypt:32768:8:1$Sq51DdBHNY8OCLur$7463fc3a7d8e03559ad1a4660315ff5e9795e19039088842db0e6fef4e6bd2a83d153b3b6a63a97b9a5b4092ca5257aba296531bb64f897c7cbf44e63376c469	\N
\.


--
-- TOC entry 3710 (class 0 OID 16612)
-- Dependencies: 229
-- Data for Name: favouritelist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favouritelist (fav_id, tutorial_id, user_id, date_time) FROM stdin;
ac53f437-c714-40c3-b084-96aee87d9b77	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	2024-03-30 14:51:39.474617+01
0865fdd1-e760-459f-b4c5-4404f1d6ef49	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	2024-03-30 14:51:39.474617+01
\.


--
-- TOC entry 3698 (class 0 OID 16482)
-- Dependencies: 217
-- Data for Name: material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material (material_id, tutorial_id, mat_title, mat_amount, mat_price, link) FROM stdin;
9b880c0e-aa0d-4943-81b1-96a1beedf80a	123e4567-e89b-12d3-a456-426614174002	Material 1 for	2	10.99	http://example.com/material1
2eb0c9b4-bcb2-41e0-9d2f-0a2f80e78dd3	123e4567-e89b-12d3-a456-426614174002	Material 2 for	1	5.99	http://example.com/material2
e1f25cfd-55a9-4eeb-bf48-d22547d0288e	223e4567-e89b-12d3-a456-426614174003	Material 1	3	7.99	http://example.com/material3
\.


--
-- TOC entry 3705 (class 0 OID 16549)
-- Dependencies: 224
-- Data for Name: picturecontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.picturecontent (id, content_picture_link, content_id) FROM stdin;
f23e4567-e89b-12d3-a456-426614174020	http://example.com/picture1.jpg	\N
82828722-b160-4f07-ae3e-703d2a890a8e	http://example.com/picture2.jpg	\N
4027d432-3022-4ab3-8d28-366eddd5b67e	http://example.com/picture3.jpg	\N
e7f60e25-8c5e-4c76-8935-3bed7fcd5b40	http://example.com/picture4.jpg	\N
f23e4567-e89b-12d3-a456-426614174036	http://example.com/picture5.jpg	\N
f23e4567-e89b-12d3-a456-426614174037	http://example.com/picture6.jpg	\N
\.


--
-- TOC entry 3711 (class 0 OID 16627)
-- Dependencies: 230
-- Data for Name: search_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.search_history (search_id, user_id, searched_text) FROM stdin;
a7be93ee-1fc5-41fc-a97e-0d79ff0e654e	123e4567-e89b-12d3-a456-426614174000	Python
a0b86591-6e02-4657-961f-8300187a15bc	223e4567-e89b-12d3-a456-426614174001	Cooking
\.


--
-- TOC entry 3702 (class 0 OID 16517)
-- Dependencies: 221
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.steps (step_id, tutorial_id, title) FROM stdin;
323e4567-e89b-12d3-a456-426614174008	123e4567-e89b-12d3-a456-426614174002	Step 1 for Tutorial 1
423e4567-e89b-12d3-a456-426614174009	123e4567-e89b-12d3-a456-426614174002	Step 2 for Tutorial 1
523e4567-e89b-12d3-a456-426614174010	223e4567-e89b-12d3-a456-426614174003	Step 1 for Tutorial 2
623e4567-e89b-12d3-a456-426614174011	223e4567-e89b-12d3-a456-426614174003	Step 2 for Tutorial 2
823e4567-e89b-12d3-a456-426614174032	123e4567-e89b-12d3-a456-426614174002	Step 3 for Tutorial 1
923e4567-e89b-12d3-a456-426614174033	123e4567-e89b-12d3-a456-426614174002	Step 4 for Tutorial 1
\.


--
-- TOC entry 3700 (class 0 OID 16502)
-- Dependencies: 219
-- Data for Name: substeps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substeps (sub_step_id, content_type, content_id) FROM stdin;
723e4567-e89b-12d3-a456-426614174012	1	b23e4567-e89b-12d3-a456-426614174016
923e4567-e89b-12d3-a456-426614174014	1	d23e4567-e89b-12d3-a456-426614174018
823e4567-e89b-12d3-a456-426614174013	1	c23e4567-e89b-12d3-a456-426614174017
a23e4567-e89b-12d3-a456-426614174015	1	e23e4567-e89b-12d3-a456-426614174019
b23e4567-e89b-12d3-a456-426614174038	1	d23e4567-e89b-12d3-a456-426614174034
b23e4567-e89b-12d3-a456-426614174039	2	f23e4567-e89b-12d3-a456-426614174036
c23e4567-e89b-12d3-a456-426614174040	1	d23e4567-e89b-12d3-a456-426614174035
c23e4567-e89b-12d3-a456-426614174041	2	f23e4567-e89b-12d3-a456-426614174037
\.


--
-- TOC entry 3703 (class 0 OID 16527)
-- Dependencies: 222
-- Data for Name: substepslist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.substepslist (sub_step_list_id, sub_step_id, step_id) FROM stdin;
34179cb4-71c6-4398-af9d-3baea7871748	723e4567-e89b-12d3-a456-426614174012	323e4567-e89b-12d3-a456-426614174008
8f2a2345-68ff-44cc-815d-228e5235b664	823e4567-e89b-12d3-a456-426614174013	323e4567-e89b-12d3-a456-426614174008
d2a8a81e-70f3-4f51-ba24-e211f4f59fb5	923e4567-e89b-12d3-a456-426614174014	423e4567-e89b-12d3-a456-426614174009
ddcc6d19-3b07-4401-9483-aa748159a0e9	a23e4567-e89b-12d3-a456-426614174015	523e4567-e89b-12d3-a456-426614174010
9a0f4f41-312b-41d6-95ee-4868726a245a	b23e4567-e89b-12d3-a456-426614174038	823e4567-e89b-12d3-a456-426614174032
43823a3d-c1c8-4ebd-81ba-248a72ee3da5	b23e4567-e89b-12d3-a456-426614174039	823e4567-e89b-12d3-a456-426614174032
a09f6f3c-a230-4dca-9427-44d7f44e962b	c23e4567-e89b-12d3-a456-426614174040	923e4567-e89b-12d3-a456-426614174033
64e2d967-913b-43a1-90b2-2560c180736b	c23e4567-e89b-12d3-a456-426614174041	923e4567-e89b-12d3-a456-426614174033
\.


--
-- TOC entry 3704 (class 0 OID 16542)
-- Dependencies: 223
-- Data for Name: textcontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.textcontent (id, content_text, content_id) FROM stdin;
b23e4567-e89b-12d3-a456-426614174016	Text content for SubStep 1 of Tutorial 1	\N
c23e4567-e89b-12d3-a456-426614174017	Text content for SubStep 2 of Tutorial 1	\N
d23e4567-e89b-12d3-a456-426614174018	Text content for SubStep 1 of Tutorial 2	\N
e23e4567-e89b-12d3-a456-426614174019	Text content for SubStep 2 of Tutorial 2	\N
d23e4567-e89b-12d3-a456-426614174034	Text content for SubStep 1 of Step 3 for Tutorial 1	\N
d23e4567-e89b-12d3-a456-426614174035	Text content for SubStep 1 of Step 4 for Tutorial 1	\N
\.


--
-- TOC entry 3699 (class 0 OID 16492)
-- Dependencies: 218
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tools (tool_id, tutorial_id, tool_title, tool_amount, link, tool_price) FROM stdin;
1e5f16d3-45b1-4096-9263-06de1e88cf59	123e4567-e89b-12d3-a456-426614174002	Tool 1 for Tutorial 1	1	http://example.com/tool1	\N
570dbca3-08a9-45ef-9e5d-9cf62273910b	123e4567-e89b-12d3-a456-426614174002	Tool 2 for Tutorial 1	2	http://example.com/tool2	\N
1e2f7257-5d46-47ee-80de-514d6a1b78c1	223e4567-e89b-12d3-a456-426614174003	Tool 1 for Tutorial 2	1	http://example.com/tool3	\N
\.


--
-- TOC entry 3709 (class 0 OID 16595)
-- Dependencies: 228
-- Data for Name: tutorialrating; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorialrating (rating_id, tutorial_id, user_id, text, rating) FROM stdin;
f1ffddcf-86f3-4d8d-a88e-4463693dabff	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	Rating 5 for Tutorial 1	5
7293aef2-5930-478b-9857-7f42cbab93b9	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	Rating 4 for Tutorial 2	4
\.


--
-- TOC entry 3697 (class 0 OID 16470)
-- Dependencies: 216
-- Data for Name: tutorials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorials (tutorial_id, title, tutorial_kind, user_id, "time", difficulty, complete, description, preview_picture_link, preview_type, views, steps) FROM stdin;
123e4567-e89b-12d3-a456-426614174002	Tutorial 1	Programming	123e4567-e89b-12d3-a456-426614174000	60	3	t	Description for Tutorial 1	http://example.com/image1.jpg	Image	100	5
223e4567-e89b-12d3-a456-426614174003	Tutorial 2	Cooking	223e4567-e89b-12d3-a456-426614174001	45	2	f	Description for Tutorial 2	http://example.com/image2.jpg	Image	50	4
\.


--
-- TOC entry 3701 (class 0 OID 16507)
-- Dependencies: 220
-- Data for Name: tutorialsearchlinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutorialsearchlinks (search_link_id, tutorial_id, name_link) FROM stdin;
\.


--
-- TOC entry 3707 (class 0 OID 16563)
-- Dependencies: 226
-- Data for Name: usercomments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usercomments (comment_id, step_id, user_id, text) FROM stdin;
1ce2849f-01c5-4725-b2c2-99d4eeb9c196	323e4567-e89b-12d3-a456-426614174008	123e4567-e89b-12d3-a456-426614174000	Comment 1 for Step 1 of Tutorial 1
f0a504ae-9e2b-45d2-98d4-26a0222a01dc	323e4567-e89b-12d3-a456-426614174008	223e4567-e89b-12d3-a456-426614174001	Comment 2 for Step 1 of Tutorial 1
0625df14-7da5-4e4f-b722-8dc23526f89b	423e4567-e89b-12d3-a456-426614174009	123e4567-e89b-12d3-a456-426614174000	Comment 1 for Step 2 of Tutorial 1
c6eaa1f8-bbc5-4260-81e4-45dc1be8fd51	523e4567-e89b-12d3-a456-426614174010	223e4567-e89b-12d3-a456-426614174001	Comment 1 for Step 1 of Tutorial 2
\.


--
-- TOC entry 3706 (class 0 OID 16556)
-- Dependencies: 225
-- Data for Name: videocontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.videocontent (id, content_video_link, content_id) FROM stdin;
c1d30dc0-a582-49d2-ae3d-5b66730b96bd	http://example.com/video1.mp4	\N
dcaeafbe-e393-4dc0-987c-8ba25c22f598	http://example.com/video2.mp4	\N
e4aec842-c2e6-4346-baa3-5d04def87dd2	http://example.com/video3.mp4	\N
a8f2e976-6ac4-4cf7-96ab-f8bcd6f7c5fb	http://example.com/video4.mp4	\N
\.


--
-- TOC entry 3708 (class 0 OID 16580)
-- Dependencies: 227
-- Data for Name: watch_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watch_history (history_id, tutorial_id, user_id, last_watched_time, completed_steps) FROM stdin;
1f03e07d-1011-4c6d-b52a-f4fd74a6bfb8	123e4567-e89b-12d3-a456-426614174002	123e4567-e89b-12d3-a456-426614174000	2024-03-30 14:51:39.474617+01	5
5e0b92f7-b144-4d60-af4d-36391b4b2a08	223e4567-e89b-12d3-a456-426614174003	223e4567-e89b-12d3-a456-426614174001	2024-03-30 14:51:39.474617+01	3
\.


--
-- TOC entry 3503 (class 2606 OID 16469)
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (user_id);


--
-- TOC entry 3531 (class 2606 OID 16616)
-- Name: favouritelist favouritelist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_pkey PRIMARY KEY (fav_id);


--
-- TOC entry 3507 (class 2606 OID 16486)
-- Name: material material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_pkey PRIMARY KEY (material_id);


--
-- TOC entry 3521 (class 2606 OID 16555)
-- Name: picturecontent picturecontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 16631)
-- Name: search_history search_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_pkey PRIMARY KEY (search_id);


--
-- TOC entry 3515 (class 2606 OID 16521)
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (step_id);


--
-- TOC entry 3511 (class 2606 OID 16506)
-- Name: substeps substeps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substeps
    ADD CONSTRAINT substeps_pkey PRIMARY KEY (sub_step_id);


--
-- TOC entry 3517 (class 2606 OID 16531)
-- Name: substepslist substepslist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_pkey PRIMARY KEY (sub_step_list_id);


--
-- TOC entry 3519 (class 2606 OID 16548)
-- Name: textcontent textcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3509 (class 2606 OID 16496)
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (tool_id);


--
-- TOC entry 3529 (class 2606 OID 16601)
-- Name: tutorialrating tutorialrating_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_pkey PRIMARY KEY (rating_id);


--
-- TOC entry 3505 (class 2606 OID 16476)
-- Name: tutorials tutorials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_pkey PRIMARY KEY (tutorial_id);


--
-- TOC entry 3513 (class 2606 OID 16511)
-- Name: tutorialsearchlinks tutorialsearchlinks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_pkey PRIMARY KEY (search_link_id);


--
-- TOC entry 3525 (class 2606 OID 16569)
-- Name: usercomments usercomments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3523 (class 2606 OID 16562)
-- Name: videocontent videocontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_pkey PRIMARY KEY (id);


--
-- TOC entry 3527 (class 2606 OID 16584)
-- Name: watch_history watch_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 3550 (class 2606 OID 16617)
-- Name: favouritelist favouritelist_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3551 (class 2606 OID 16622)
-- Name: favouritelist favouritelist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favouritelist
    ADD CONSTRAINT favouritelist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- TOC entry 3535 (class 2606 OID 16487)
-- Name: material material_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material
    ADD CONSTRAINT material_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3542 (class 2606 OID 16652)
-- Name: picturecontent picturecontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.picturecontent
    ADD CONSTRAINT picturecontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- TOC entry 3552 (class 2606 OID 16632)
-- Name: search_history search_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_history
    ADD CONSTRAINT search_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- TOC entry 3538 (class 2606 OID 16522)
-- Name: steps steps_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3539 (class 2606 OID 16537)
-- Name: substepslist substepslist_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);


--
-- TOC entry 3540 (class 2606 OID 16532)
-- Name: substepslist substepslist_sub_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.substepslist
    ADD CONSTRAINT substepslist_sub_step_id_fkey FOREIGN KEY (sub_step_id) REFERENCES public.substeps(sub_step_id);


--
-- TOC entry 3541 (class 2606 OID 16657)
-- Name: textcontent textcontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.textcontent
    ADD CONSTRAINT textcontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- TOC entry 3536 (class 2606 OID 16497)
-- Name: tools tools_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3548 (class 2606 OID 16602)
-- Name: tutorialrating tutorialrating_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3549 (class 2606 OID 16607)
-- Name: tutorialrating tutorialrating_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialrating
    ADD CONSTRAINT tutorialrating_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- TOC entry 3534 (class 2606 OID 16477)
-- Name: tutorials tutorials_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorials
    ADD CONSTRAINT tutorials_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- TOC entry 3537 (class 2606 OID 16512)
-- Name: tutorialsearchlinks tutorialsearchlinks_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutorialsearchlinks
    ADD CONSTRAINT tutorialsearchlinks_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3544 (class 2606 OID 16570)
-- Name: usercomments usercomments_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_step_id_fkey FOREIGN KEY (step_id) REFERENCES public.steps(step_id);


--
-- TOC entry 3545 (class 2606 OID 16575)
-- Name: usercomments usercomments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usercomments
    ADD CONSTRAINT usercomments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


--
-- TOC entry 3543 (class 2606 OID 16662)
-- Name: videocontent videocontent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.videocontent
    ADD CONSTRAINT videocontent_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.substeps(sub_step_id) ON DELETE CASCADE;


--
-- TOC entry 3546 (class 2606 OID 16585)
-- Name: watch_history watch_history_tutorial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_tutorial_id_fkey FOREIGN KEY (tutorial_id) REFERENCES public.tutorials(tutorial_id);


--
-- TOC entry 3547 (class 2606 OID 16590)
-- Name: watch_history watch_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watch_history
    ADD CONSTRAINT watch_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."User"(user_id);


-- Completed on 2024-04-09 10:31:07 IST

--
-- PostgreSQL database dump complete
--

