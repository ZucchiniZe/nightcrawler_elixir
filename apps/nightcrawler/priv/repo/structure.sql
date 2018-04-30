--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    id bigint NOT NULL,
    name character varying(255),
    description text,
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: comics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comics (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    reader_id integer,
    issue_number double precision,
    isbn character varying(255),
    format character varying(255),
    page_count double precision,
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    series_id bigint,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comics_id_seq OWNED BY public.comics.id;


--
-- Name: creators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creators (
    id bigint NOT NULL,
    first_name character varying(255),
    middle_name character varying(255),
    last_name character varying(255),
    suffix character varying(255),
    full_name character varying(255),
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: creators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.creators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: creators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.creators_id_seq OWNED BY public.creators.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    start date,
    "end" date,
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series (
    id bigint NOT NULL,
    title character varying(255),
    description text,
    start_year integer,
    end_year integer,
    rating character varying(255),
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: series_characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_characters (
    id bigint NOT NULL,
    series_id bigint,
    character_id bigint
);


--
-- Name: series_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.series_characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: series_characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.series_characters_id_seq OWNED BY public.series_characters.id;


--
-- Name: series_creators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_creators (
    id bigint NOT NULL,
    series_id bigint,
    creator_id bigint
);


--
-- Name: series_creators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.series_creators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: series_creators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.series_creators_id_seq OWNED BY public.series_creators.id;


--
-- Name: series_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.series_events (
    id bigint NOT NULL,
    series_id bigint,
    event_id bigint
);


--
-- Name: series_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.series_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: series_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.series_events_id_seq OWNED BY public.series_events.id;


--
-- Name: series_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.series_id_seq OWNED BY public.series.id;


--
-- Name: stories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stories (
    id bigint NOT NULL,
    title character varying(255),
    description character varying(255),
    type character varying(255),
    modified timestamp without time zone,
    thumbnail jsonb DEFAULT '[]'::jsonb,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stories_id_seq OWNED BY public.stories.id;


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: comics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comics ALTER COLUMN id SET DEFAULT nextval('public.comics_id_seq'::regclass);


--
-- Name: creators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creators ALTER COLUMN id SET DEFAULT nextval('public.creators_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: series id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series ALTER COLUMN id SET DEFAULT nextval('public.series_id_seq'::regclass);


--
-- Name: series_characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_characters ALTER COLUMN id SET DEFAULT nextval('public.series_characters_id_seq'::regclass);


--
-- Name: series_creators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_creators ALTER COLUMN id SET DEFAULT nextval('public.series_creators_id_seq'::regclass);


--
-- Name: series_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_events ALTER COLUMN id SET DEFAULT nextval('public.series_events_id_seq'::regclass);


--
-- Name: stories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stories ALTER COLUMN id SET DEFAULT nextval('public.stories_id_seq'::regclass);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: comics comics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comics
    ADD CONSTRAINT comics_pkey PRIMARY KEY (id);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: series_characters series_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_characters
    ADD CONSTRAINT series_characters_pkey PRIMARY KEY (id);


--
-- Name: series_creators series_creators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_creators
    ADD CONSTRAINT series_creators_pkey PRIMARY KEY (id);


--
-- Name: series_events series_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_events
    ADD CONSTRAINT series_events_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: stories stories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stories
    ADD CONSTRAINT stories_pkey PRIMARY KEY (id);


--
-- Name: series_characters_series_id_character_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX series_characters_series_id_character_id_index ON public.series_characters USING btree (series_id, character_id);


--
-- Name: series_creators_series_id_creator_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX series_creators_series_id_creator_id_index ON public.series_creators USING btree (series_id, creator_id);


--
-- Name: series_events_series_id_event_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX series_events_series_id_event_id_index ON public.series_events USING btree (series_id, event_id);


--
-- Name: comics comics_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comics
    ADD CONSTRAINT comics_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: series_characters series_characters_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_characters
    ADD CONSTRAINT series_characters_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: series_characters series_characters_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_characters
    ADD CONSTRAINT series_characters_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: series_creators series_creators_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_creators
    ADD CONSTRAINT series_creators_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.creators(id);


--
-- Name: series_creators series_creators_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_creators
    ADD CONSTRAINT series_creators_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- Name: series_events series_events_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_events
    ADD CONSTRAINT series_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: series_events series_events_series_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.series_events
    ADD CONSTRAINT series_events_series_id_fkey FOREIGN KEY (series_id) REFERENCES public.series(id);


--
-- PostgreSQL database dump complete
--
