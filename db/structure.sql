--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin_administrators; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_administrators (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_administrators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_administrators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_administrators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_administrators_id_seq OWNED BY admin_administrators.id;


--
-- Name: admin_markdown_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_markdown_pages (
    id integer NOT NULL,
    name character varying(255),
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_markdown_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_markdown_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_markdown_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_markdown_pages_id_seq OWNED BY admin_markdown_pages.id;


--
-- Name: admin_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_settings (
    id integer NOT NULL,
    key character varying(255),
    value text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_settings_id_seq OWNED BY admin_settings.id;


--
-- Name: admin_uploaded_asset_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_uploaded_asset_files (
    id integer NOT NULL,
    admin_uploaded_asset_id integer,
    style character varying(255),
    file_contents bytea
);


--
-- Name: admin_uploaded_asset_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_uploaded_asset_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_uploaded_asset_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_uploaded_asset_files_id_seq OWNED BY admin_uploaded_asset_files.id;


--
-- Name: admin_uploaded_assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_uploaded_assets (
    id integer NOT NULL,
    name character varying(255),
    file_file_name character varying(255),
    file_content_type character varying(255),
    file_file_size integer,
    file_updated_at timestamp without time zone,
    file_fingerprint character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: admin_uploaded_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_uploaded_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_uploaded_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_uploaded_assets_id_seq OWNED BY admin_uploaded_assets.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets (
    id integer NOT NULL,
    name character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    disabled boolean,
    "fetch" boolean DEFAULT false
);


--
-- Name: datasets_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets_entries (
    id integer NOT NULL,
    uid character varying(255),
    dataset_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: datasets_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_entries_id_seq OWNED BY datasets_entries.id;


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_id_seq OWNED BY datasets.id;


--
-- Name: datasets_task_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets_task_results (
    id integer NOT NULL,
    datasets_task_id integer,
    style character varying(255),
    file_contents bytea
);


--
-- Name: datasets_task_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_task_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_task_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_task_results_id_seq OWNED BY datasets_task_results.id;


--
-- Name: datasets_tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE datasets_tasks (
    id integer NOT NULL,
    name character varying(255),
    finished_at timestamp without time zone,
    dataset_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    failed boolean DEFAULT false,
    job_type character varying(255),
    result_file_name character varying(255),
    result_content_type character varying(255),
    result_file_size integer,
    result_updated_at timestamp without time zone,
    params text,
    resque_key character varying(255)
);


--
-- Name: datasets_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE datasets_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE datasets_tasks_id_seq OWNED BY datasets_tasks.id;


--
-- Name: documents_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents_categories (
    id integer NOT NULL,
    parent_id integer,
    sort_order integer,
    name character varying(255),
    journals text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: documents_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_categories_id_seq OWNED BY documents_categories.id;


--
-- Name: documents_category_hierarchies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents_category_hierarchies (
    ancestor_id integer NOT NULL,
    descendant_id integer NOT NULL,
    generations integer NOT NULL
);


--
-- Name: documents_stop_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents_stop_lists (
    id integer NOT NULL,
    language character varying(255),
    list text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: documents_stop_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_stop_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_stop_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_stop_lists_id_seq OWNED BY documents_stop_lists.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    per_page integer DEFAULT 10,
    language character varying(255) DEFAULT 'en'::character varying,
    timezone character varying(255) DEFAULT 'Eastern Time (US & Canada)'::character varying,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    csl_style_id integer,
    workflow_active boolean DEFAULT false,
    workflow_class character varying(255),
    workflow_datasets text[] DEFAULT '{}'::text[]
);


--
-- Name: users_csl_styles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_csl_styles (
    id integer NOT NULL,
    name character varying(255),
    style text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_csl_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_csl_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_csl_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_csl_styles_id_seq OWNED BY users_csl_styles.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_libraries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users_libraries (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_libraries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_libraries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_libraries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_libraries_id_seq OWNED BY users_libraries.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_administrators ALTER COLUMN id SET DEFAULT nextval('admin_administrators_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_markdown_pages ALTER COLUMN id SET DEFAULT nextval('admin_markdown_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_settings ALTER COLUMN id SET DEFAULT nextval('admin_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_uploaded_asset_files ALTER COLUMN id SET DEFAULT nextval('admin_uploaded_asset_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_uploaded_assets ALTER COLUMN id SET DEFAULT nextval('admin_uploaded_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets ALTER COLUMN id SET DEFAULT nextval('datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets_entries ALTER COLUMN id SET DEFAULT nextval('datasets_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets_task_results ALTER COLUMN id SET DEFAULT nextval('datasets_task_results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets_tasks ALTER COLUMN id SET DEFAULT nextval('datasets_tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents_categories ALTER COLUMN id SET DEFAULT nextval('documents_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents_stop_lists ALTER COLUMN id SET DEFAULT nextval('documents_stop_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_csl_styles ALTER COLUMN id SET DEFAULT nextval('users_csl_styles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_libraries ALTER COLUMN id SET DEFAULT nextval('users_libraries_id_seq'::regclass);


--
-- Name: admin_administrators_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_administrators
    ADD CONSTRAINT admin_administrators_pkey PRIMARY KEY (id);


--
-- Name: admin_markdown_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_markdown_pages
    ADD CONSTRAINT admin_markdown_pages_pkey PRIMARY KEY (id);


--
-- Name: admin_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_settings
    ADD CONSTRAINT admin_settings_pkey PRIMARY KEY (id);


--
-- Name: admin_uploaded_asset_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_uploaded_asset_files
    ADD CONSTRAINT admin_uploaded_asset_files_pkey PRIMARY KEY (id);


--
-- Name: admin_uploaded_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_uploaded_assets
    ADD CONSTRAINT admin_uploaded_assets_pkey PRIMARY KEY (id);


--
-- Name: datasets_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets_entries
    ADD CONSTRAINT datasets_entries_pkey PRIMARY KEY (id);


--
-- Name: datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: datasets_task_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets_task_results
    ADD CONSTRAINT datasets_task_results_pkey PRIMARY KEY (id);


--
-- Name: datasets_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY datasets_tasks
    ADD CONSTRAINT datasets_tasks_pkey PRIMARY KEY (id);


--
-- Name: documents_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents_categories
    ADD CONSTRAINT documents_categories_pkey PRIMARY KEY (id);


--
-- Name: documents_stop_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents_stop_lists
    ADD CONSTRAINT documents_stop_lists_pkey PRIMARY KEY (id);


--
-- Name: users_csl_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_csl_styles
    ADD CONSTRAINT users_csl_styles_pkey PRIMARY KEY (id);


--
-- Name: users_libraries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users_libraries
    ADD CONSTRAINT users_libraries_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: documents_category_anc_desc_udx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX documents_category_anc_desc_udx ON documents_category_hierarchies USING btree (ancestor_id, descendant_id, generations);


--
-- Name: documents_category_desc_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX documents_category_desc_idx ON documents_category_hierarchies USING btree (descendant_id);


--
-- Name: index_admin_administrators_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_administrators_on_email ON admin_administrators USING btree (email);


--
-- Name: index_admin_administrators_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_administrators_on_reset_password_token ON admin_administrators USING btree (reset_password_token);


--
-- Name: index_datasets_entries_on_dataset_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_datasets_entries_on_dataset_id ON datasets_entries USING btree (dataset_id);


--
-- Name: index_datasets_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_datasets_on_user_id ON datasets USING btree (user_id);


--
-- Name: index_datasets_tasks_on_dataset_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_datasets_tasks_on_dataset_id ON datasets_tasks USING btree (dataset_id);


--
-- Name: index_users_libraries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_libraries_on_user_id ON users_libraries USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: key_udx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX key_udx ON admin_settings USING btree (key);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: datasets_analysis_tasks_dataset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets_tasks
    ADD CONSTRAINT datasets_analysis_tasks_dataset_id_fk FOREIGN KEY (dataset_id) REFERENCES datasets(id);


--
-- Name: datasets_entries_dataset_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets_entries
    ADD CONSTRAINT datasets_entries_dataset_id_fk FOREIGN KEY (dataset_id) REFERENCES datasets(id) ON DELETE CASCADE;


--
-- Name: datasets_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: documents_categories_parent_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents_categories
    ADD CONSTRAINT documents_categories_parent_id_fk FOREIGN KEY (parent_id) REFERENCES documents_categories(id);


--
-- Name: documents_category_hierarchies_ancestor_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents_category_hierarchies
    ADD CONSTRAINT documents_category_hierarchies_ancestor_id_fk FOREIGN KEY (ancestor_id) REFERENCES documents_categories(id);


--
-- Name: documents_category_hierarchies_descendant_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents_category_hierarchies
    ADD CONSTRAINT documents_category_hierarchies_descendant_id_fk FOREIGN KEY (descendant_id) REFERENCES documents_categories(id);


--
-- Name: users_libraries_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users_libraries
    ADD CONSTRAINT users_libraries_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20110908133632');

INSERT INTO schema_migrations (version) VALUES ('20110908232625');

INSERT INTO schema_migrations (version) VALUES ('20110916203031');

INSERT INTO schema_migrations (version) VALUES ('20110928165308');

INSERT INTO schema_migrations (version) VALUES ('20110929135437');

INSERT INTO schema_migrations (version) VALUES ('20111001233930');

INSERT INTO schema_migrations (version) VALUES ('20111018003510');

INSERT INTO schema_migrations (version) VALUES ('20111024225019');

INSERT INTO schema_migrations (version) VALUES ('20111122135408');

INSERT INTO schema_migrations (version) VALUES ('20111205172114');

INSERT INTO schema_migrations (version) VALUES ('20111205185208');

INSERT INTO schema_migrations (version) VALUES ('20111206000437');

INSERT INTO schema_migrations (version) VALUES ('20120105150524');

INSERT INTO schema_migrations (version) VALUES ('20120123202818');

INSERT INTO schema_migrations (version) VALUES ('20120124192349');

INSERT INTO schema_migrations (version) VALUES ('20121207143836');

INSERT INTO schema_migrations (version) VALUES ('20130109194840');

INSERT INTO schema_migrations (version) VALUES ('20130109194902');

INSERT INTO schema_migrations (version) VALUES ('20130109194903');

INSERT INTO schema_migrations (version) VALUES ('20130109223820');

INSERT INTO schema_migrations (version) VALUES ('20130110034148');

INSERT INTO schema_migrations (version) VALUES ('20130112012448');

INSERT INTO schema_migrations (version) VALUES ('20130112042432');

INSERT INTO schema_migrations (version) VALUES ('20130112162822');

INSERT INTO schema_migrations (version) VALUES ('20130311180722');

INSERT INTO schema_migrations (version) VALUES ('20130731220528');

INSERT INTO schema_migrations (version) VALUES ('20130731222054');

INSERT INTO schema_migrations (version) VALUES ('20130801021934');

INSERT INTO schema_migrations (version) VALUES ('20130801202821');

INSERT INTO schema_migrations (version) VALUES ('20130806005057');

INSERT INTO schema_migrations (version) VALUES ('20130917194623');

INSERT INTO schema_migrations (version) VALUES ('20130917195215');

INSERT INTO schema_migrations (version) VALUES ('20130917195220');

INSERT INTO schema_migrations (version) VALUES ('20130917195527');

INSERT INTO schema_migrations (version) VALUES ('20130920174611');

INSERT INTO schema_migrations (version) VALUES ('20131017161525');

INSERT INTO schema_migrations (version) VALUES ('20131022151607');

INSERT INTO schema_migrations (version) VALUES ('20131031130451');

INSERT INTO schema_migrations (version) VALUES ('20131031190215');

INSERT INTO schema_migrations (version) VALUES ('20131105202034');

INSERT INTO schema_migrations (version) VALUES ('20131110162848');

INSERT INTO schema_migrations (version) VALUES ('20131110184843');

INSERT INTO schema_migrations (version) VALUES ('20131110210646');

INSERT INTO schema_migrations (version) VALUES ('20131110214442');

INSERT INTO schema_migrations (version) VALUES ('20131112153938');

INSERT INTO schema_migrations (version) VALUES ('20131114011634');

INSERT INTO schema_migrations (version) VALUES ('20131114044009');

INSERT INTO schema_migrations (version) VALUES ('20131117181239');

INSERT INTO schema_migrations (version) VALUES ('20131117182828');

INSERT INTO schema_migrations (version) VALUES ('20131122160941');

INSERT INTO schema_migrations (version) VALUES ('20131204171642');

INSERT INTO schema_migrations (version) VALUES ('20131224154209');

INSERT INTO schema_migrations (version) VALUES ('20140523162748');

INSERT INTO schema_migrations (version) VALUES ('20150321205255');

INSERT INTO schema_migrations (version) VALUES ('20150704144210');
