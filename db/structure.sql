--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    contact_id integer NOT NULL,
    institution character varying(255),
    department character varying(255),
    street character varying(255) NOT NULL,
    building_floor_suite_room character varying(255),
    city character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    zip character varying(255) NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admin_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_assignments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    schedule_id integer NOT NULL,
    is_vacation_request_subscriber boolean DEFAULT true NOT NULL
);


--
-- Name: admin_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_assignments_id_seq OWNED BY admin_assignments.id;


--
-- Name: allowed_shift_overlaps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE allowed_shift_overlaps (
    id integer NOT NULL,
    shift_a_id integer NOT NULL,
    shift_b_id integer NOT NULL
);


--
-- Name: allowed_shift_overlaps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE allowed_shift_overlaps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allowed_shift_overlaps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE allowed_shift_overlaps_id_seq OWNED BY allowed_shift_overlaps.id;


--
-- Name: assignment_labels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignment_labels (
    id integer NOT NULL,
    shift_id integer NOT NULL,
    text character varying(255) NOT NULL
);


--
-- Name: assignment_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignment_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignment_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignment_labels_id_seq OWNED BY assignment_labels.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
    id integer NOT NULL,
    shift_id integer NOT NULL,
    person_id integer NOT NULL,
    date date NOT NULL,
    public_note character varying(255),
    private_note character varying(255),
    duration numeric(2,1),
    starts_at time without time zone,
    ends_at time without time zone,
    label_id integer,
    editor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: calendar_audits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calendar_audits (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    date date NOT NULL,
    log text NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: calendar_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calendar_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calendar_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calendar_audits_id_seq OWNED BY calendar_audits.id;


--
-- Name: cme_meeting_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cme_meeting_requests (
    id integer NOT NULL,
    requester_id integer NOT NULL,
    schedule_id integer NOT NULL,
    shift_id integer NOT NULL,
    status character varying(60) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    meeting_start_date date NOT NULL,
    meeting_end_date date NOT NULL,
    description character varying(255) NOT NULL,
    person_id integer NOT NULL,
    events text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cme_meeting_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cme_meeting_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cme_meeting_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cme_meeting_requests_id_seq OWNED BY cme_meeting_requests.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    given_name character varying(255) NOT NULL,
    slug character varying(255),
    other_given_names character varying(255),
    family_name character varying(255),
    photo_uid character varying(255),
    suffix character varying(255),
    titles character varying(255),
    degrees character varying(255),
    employment_starts_on date,
    employment_ends_on date,
    email character varying(255),
    phone character varying(255),
    fax character varying(255),
    pager character varying(255),
    alpha_pager character varying(255),
    address_id integer,
    pubmed_search_term character varying(255),
    netid character varying(255),
    updated_at timestamp without time zone
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: day_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE day_notes (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    date date NOT NULL,
    public_text character varying(255),
    private_text character varying(255)
);


--
-- Name: day_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE day_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE day_notes_id_seq OWNED BY day_notes.id;


--
-- Name: deleted_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deleted_assignments (
    id integer NOT NULL,
    shift_id integer NOT NULL,
    person_id integer NOT NULL,
    date date,
    public_note character varying(255),
    private_note character varying(255),
    duration numeric(2,1),
    starts_at time without time zone,
    ends_at time without time zone,
    label_id integer,
    editor_id integer,
    original_created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: deleted_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deleted_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deleted_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deleted_assignments_id_seq OWNED BY deleted_assignments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    schedule_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT dates_valid CHECK ((start_date <= end_date))
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: funding_sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE funding_sources (
    id integer NOT NULL,
    type character varying(255),
    title character varying(255),
    requires_description boolean NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: funding_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE funding_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: funding_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE funding_sources_id_seq OWNED BY funding_sources.id;


--
-- Name: guest_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE guest_assignments (
    id integer NOT NULL,
    shift_id integer NOT NULL,
    guest_membership_id integer NOT NULL,
    date date NOT NULL,
    editor_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: guest_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE guest_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guest_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE guest_assignments_id_seq OWNED BY guest_assignments.id;


--
-- Name: guest_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE guest_memberships (
    id integer NOT NULL,
    schedule_id integer,
    family_name character varying(255),
    given_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: guest_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE guest_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guest_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE guest_memberships_id_seq OWNED BY guest_memberships.id;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE holidays (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    date date NOT NULL
);


--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE holidays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE holidays_id_seq OWNED BY holidays.id;


--
-- Name: nmff_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE nmff_statuses (
    id integer NOT NULL,
    person_id integer NOT NULL,
    hire_date date NOT NULL,
    fte numeric(3,2) DEFAULT 1.0 NOT NULL,
    carryover text,
    CONSTRAINT fte_valid CHECK (((fte >= (0)::numeric) AND (fte <= (1)::numeric)))
);


--
-- Name: nmff_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE nmff_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: nmff_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE nmff_statuses_id_seq OWNED BY nmff_statuses.id;


--
-- Name: outside_fund_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE outside_fund_assignments (
    id integer NOT NULL,
    meeting_request_id integer,
    meeting_request_type character varying(255),
    description character varying(255),
    outside_source_fund_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: outside_fund_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE outside_fund_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outside_fund_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE outside_fund_assignments_id_seq OWNED BY outside_fund_assignments.id;


--
-- Name: professional_fund_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE professional_fund_assignments (
    id integer NOT NULL,
    meeting_request_id integer,
    meeting_request_type character varying(255),
    description character varying(255),
    professional_fund_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: professional_fund_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE professional_fund_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: professional_fund_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE professional_fund_assignments_id_seq OWNED BY professional_fund_assignments.id;


--
-- Name: schedule_shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_shifts (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    shift_id integer NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    display_color character varying(255),
    retired_on date,
    hide_from_aggregate boolean DEFAULT false NOT NULL
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedules (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    open_reports boolean DEFAULT false NOT NULL,
    allow_switch_offers boolean DEFAULT false NOT NULL,
    accept_vacation_requests boolean DEFAULT false NOT NULL,
    vacation_request_max_days_advance integer DEFAULT 0 NOT NULL,
    vacation_request_min_days_advance integer DEFAULT 0 NOT NULL,
    accept_meeting_requests boolean DEFAULT false NOT NULL,
    meeting_request_max_days_advance integer DEFAULT 0 NOT NULL,
    meeting_request_min_days_advance integer DEFAULT 0 NOT NULL,
    CONSTRAINT meet_req_days_valid CHECK ((((((meeting_request_min_days_advance <= meeting_request_max_days_advance) AND (meeting_request_min_days_advance >= 0)) AND (meeting_request_min_days_advance < 4000)) AND (meeting_request_max_days_advance >= 0)) AND (meeting_request_max_days_advance < 4000))),
    CONSTRAINT vac_req_days_valid CHECK ((((((vacation_request_min_days_advance <= vacation_request_max_days_advance) AND (vacation_request_min_days_advance >= 0)) AND (vacation_request_min_days_advance < 4000)) AND (vacation_request_max_days_advance >= 0)) AND (vacation_request_max_days_advance < 4000)))
);


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shifts (
    id integer NOT NULL,
    type character varying(255),
    title character varying(255) NOT NULL,
    duration numeric(2,1) DEFAULT 0.5 NOT NULL,
    phone character varying(255),
    starts_at time without time zone NOT NULL,
    ends_at time without time zone NOT NULL,
    show_unpublished boolean DEFAULT false NOT NULL,
    recurrence text,
    updated_at timestamp without time zone,
    CONSTRAINT type_valid CHECK (((type IS NULL) OR ((type)::text = ANY ((ARRAY['CallShift'::character varying, 'VacationShift'::character varying, 'CmeMeetingShift'::character varying])::text[]))))
);


--
-- Name: weekly_calendars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weekly_calendars (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    date date NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: published_shift_weeks; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW published_shift_weeks AS
    SELECT ss.shift_id, ARRAY[wc.date, (wc.date + 1), (wc.date + 2), (wc.date + 3), (wc.date + 4), (wc.date + 5), (wc.date + 6)] AS dates, array_agg(s.id) AS schedule_ids FROM ((schedules s JOIN (SELECT schedule_shifts.id, schedule_shifts.schedule_id, schedule_shifts.shift_id, schedule_shifts."position", schedule_shifts.display_color, schedule_shifts.retired_on, schedule_shifts.hide_from_aggregate, shifts.id, shifts.type, shifts.title, shifts.duration, shifts.phone, shifts.starts_at, shifts.ends_at, shifts.show_unpublished, shifts.recurrence, shifts.updated_at FROM (schedule_shifts JOIN shifts ON ((shifts.id = schedule_shifts.shift_id)))) ss ON ((ss.schedule_id = s.id))) JOIN weekly_calendars wc ON ((wc.schedule_id = s.id))) WHERE (((wc.is_published = true) OR (ss.show_unpublished = true)) AND ((ss.retired_on IS NULL) OR (ss.retired_on > wc.date))) GROUP BY ss.shift_id, wc.date;


--
-- Name: rotation_assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rotation_assignments (
    id integer NOT NULL,
    person_id integer NOT NULL,
    rotation_id integer NOT NULL,
    starts_on date NOT NULL,
    ends_on date NOT NULL,
    editor_id integer,
    is_deleted boolean DEFAULT false NOT NULL,
    rotation_schedule_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rotation_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rotation_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rotation_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rotation_assignments_id_seq OWNED BY rotation_assignments.id;


--
-- Name: rotation_schedules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rotation_schedules (
    id integer NOT NULL,
    start_date date NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    end_date date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rotation_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rotation_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rotation_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rotation_schedules_id_seq OWNED BY rotation_schedules.id;


--
-- Name: rotations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rotations (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    active_on date DEFAULT '1000-01-01'::date NOT NULL,
    retired_on date DEFAULT '9999-12-31'::date NOT NULL,
    display_color character varying(7) DEFAULT '#7A43B6'::character varying NOT NULL,
    CONSTRAINT dates_valid CHECK ((retired_on > active_on))
);


--
-- Name: rotations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rotations_id_seq OWNED BY rotations.id;


--
-- Name: schedule_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_memberships (
    id integer NOT NULL,
    person_id integer NOT NULL,
    schedule_id integer NOT NULL,
    fte numeric(3,2) DEFAULT 1.0 NOT NULL,
    initials character varying(255),
    disable_notifications boolean DEFAULT false NOT NULL,
    CONSTRAINT fte_valid CHECK (((fte > (0)::numeric) AND (fte <= (1)::numeric)))
);


--
-- Name: schedule_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_memberships_id_seq OWNED BY schedule_memberships.id;


--
-- Name: schedule_rotations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule_rotations (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    rotation_id integer NOT NULL
);


--
-- Name: schedule_rotations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_rotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_rotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_rotations_id_seq OWNED BY schedule_rotations.id;


--
-- Name: schedule_shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_shifts_id_seq OWNED BY schedule_shifts.id;


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedules_id_seq OWNED BY schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: shift_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shift_groups (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    schedule_id integer NOT NULL,
    shift_ids text,
    "position" integer DEFAULT 0 NOT NULL
);


--
-- Name: shift_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shift_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shift_groups_id_seq OWNED BY shift_groups.id;


--
-- Name: shift_totals_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shift_totals_reports (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    end_date_is_today boolean NOT NULL,
    include_unpublished boolean NOT NULL,
    shift_ids text NOT NULL,
    groups text NOT NULL,
    hide_empty_shifts boolean NOT NULL,
    schedule_id integer NOT NULL
);


--
-- Name: shift_totals_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shift_totals_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_totals_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shift_totals_reports_id_seq OWNED BY shift_totals_reports.id;


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shifts_id_seq OWNED BY shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    admin boolean DEFAULT false,
    person_id integer,
    username character varying(255) NOT NULL,
    password_digest character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    given_name character varying(255),
    family_name character varying(255),
    reset_token character varying(255),
    last_login_timestamp timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


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
-- Name: vacation_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vacation_requests (
    id integer NOT NULL,
    requester_id integer NOT NULL,
    schedule_id integer NOT NULL,
    shift_id integer NOT NULL,
    status character varying(60) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    comments text,
    person_id integer NOT NULL,
    events text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: vacation_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vacation_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vacation_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vacation_requests_id_seq OWNED BY vacation_requests.id;


--
-- Name: weekly_calendars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weekly_calendars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weekly_calendars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weekly_calendars_id_seq OWNED BY weekly_calendars.id;


--
-- Name: weekly_shift_duration_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weekly_shift_duration_rules (
    id integer NOT NULL,
    schedule_id integer NOT NULL,
    maximum numeric(4,1),
    minimum numeric(4,1),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT max_min_valid CHECK ((((((maximum >= minimum) AND (maximum >= (0)::numeric)) AND (maximum <= 999.9)) AND (minimum >= (0)::numeric)) AND (minimum <= 999.9)))
);


--
-- Name: weekly_shift_duration_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weekly_shift_duration_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weekly_shift_duration_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weekly_shift_duration_rules_id_seq OWNED BY weekly_shift_duration_rules.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_assignments ALTER COLUMN id SET DEFAULT nextval('admin_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY allowed_shift_overlaps ALTER COLUMN id SET DEFAULT nextval('allowed_shift_overlaps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_labels ALTER COLUMN id SET DEFAULT nextval('assignment_labels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendar_audits ALTER COLUMN id SET DEFAULT nextval('calendar_audits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cme_meeting_requests ALTER COLUMN id SET DEFAULT nextval('cme_meeting_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY day_notes ALTER COLUMN id SET DEFAULT nextval('day_notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deleted_assignments ALTER COLUMN id SET DEFAULT nextval('deleted_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY funding_sources ALTER COLUMN id SET DEFAULT nextval('funding_sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_assignments ALTER COLUMN id SET DEFAULT nextval('guest_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_memberships ALTER COLUMN id SET DEFAULT nextval('guest_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY holidays ALTER COLUMN id SET DEFAULT nextval('holidays_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY nmff_statuses ALTER COLUMN id SET DEFAULT nextval('nmff_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY outside_fund_assignments ALTER COLUMN id SET DEFAULT nextval('outside_fund_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY professional_fund_assignments ALTER COLUMN id SET DEFAULT nextval('professional_fund_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_assignments ALTER COLUMN id SET DEFAULT nextval('rotation_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_schedules ALTER COLUMN id SET DEFAULT nextval('rotation_schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotations ALTER COLUMN id SET DEFAULT nextval('rotations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_memberships ALTER COLUMN id SET DEFAULT nextval('schedule_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_rotations ALTER COLUMN id SET DEFAULT nextval('schedule_rotations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_shifts ALTER COLUMN id SET DEFAULT nextval('schedule_shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedules ALTER COLUMN id SET DEFAULT nextval('schedules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_groups ALTER COLUMN id SET DEFAULT nextval('shift_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_totals_reports ALTER COLUMN id SET DEFAULT nextval('shift_totals_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shifts ALTER COLUMN id SET DEFAULT nextval('shifts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacation_requests ALTER COLUMN id SET DEFAULT nextval('vacation_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weekly_calendars ALTER COLUMN id SET DEFAULT nextval('weekly_calendars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weekly_shift_duration_rules ALTER COLUMN id SET DEFAULT nextval('weekly_shift_duration_rules_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_assignments
    ADD CONSTRAINT admin_assignments_pkey PRIMARY KEY (id);


--
-- Name: allowed_shift_overlaps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY allowed_shift_overlaps
    ADD CONSTRAINT allowed_shift_overlaps_pkey PRIMARY KEY (id);


--
-- Name: assignment_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignment_labels
    ADD CONSTRAINT assignment_labels_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: calendar_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calendar_audits
    ADD CONSTRAINT calendar_audits_pkey PRIMARY KEY (id);


--
-- Name: cme_meeting_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cme_meeting_requests
    ADD CONSTRAINT cme_meeting_requests_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: day_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY day_notes
    ADD CONSTRAINT day_notes_pkey PRIMARY KEY (id);


--
-- Name: deleted_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deleted_assignments
    ADD CONSTRAINT deleted_assignments_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: funding_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY funding_sources
    ADD CONSTRAINT funding_sources_pkey PRIMARY KEY (id);


--
-- Name: guest_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY guest_assignments
    ADD CONSTRAINT guest_assignments_pkey PRIMARY KEY (id);


--
-- Name: guest_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY guest_memberships
    ADD CONSTRAINT guest_memberships_pkey PRIMARY KEY (id);


--
-- Name: holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: nmff_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY nmff_statuses
    ADD CONSTRAINT nmff_statuses_pkey PRIMARY KEY (id);


--
-- Name: outside_fund_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY outside_fund_assignments
    ADD CONSTRAINT outside_fund_assignments_pkey PRIMARY KEY (id);


--
-- Name: professional_fund_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY professional_fund_assignments
    ADD CONSTRAINT professional_fund_assignments_pkey PRIMARY KEY (id);


--
-- Name: rotation_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rotation_assignments
    ADD CONSTRAINT rotation_assignments_pkey PRIMARY KEY (id);


--
-- Name: rotation_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rotation_schedules
    ADD CONSTRAINT rotation_schedules_pkey PRIMARY KEY (id);


--
-- Name: rotations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rotations
    ADD CONSTRAINT rotations_pkey PRIMARY KEY (id);


--
-- Name: schedule_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_memberships
    ADD CONSTRAINT schedule_memberships_pkey PRIMARY KEY (id);


--
-- Name: schedule_rotations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_rotations
    ADD CONSTRAINT schedule_rotations_pkey PRIMARY KEY (id);


--
-- Name: schedule_shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule_shifts
    ADD CONSTRAINT schedule_shifts_pkey PRIMARY KEY (id);


--
-- Name: schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: shift_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shift_groups
    ADD CONSTRAINT shift_groups_pkey PRIMARY KEY (id);


--
-- Name: shift_totals_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shift_totals_reports
    ADD CONSTRAINT shift_totals_reports_pkey PRIMARY KEY (id);


--
-- Name: shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vacation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY vacation_requests
    ADD CONSTRAINT vacation_requests_pkey PRIMARY KEY (id);


--
-- Name: weekly_calendars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weekly_calendars
    ADD CONSTRAINT weekly_calendars_pkey PRIMARY KEY (id);


--
-- Name: weekly_shift_duration_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weekly_shift_duration_rules
    ADD CONSTRAINT weekly_shift_duration_rules_pkey PRIMARY KEY (id);


--
-- Name: guest_shift_date_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX guest_shift_date_index ON guest_assignments USING btree (guest_membership_id, shift_id, date);


--
-- Name: index_addresses_on_contact_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_addresses_on_contact_id ON addresses USING btree (contact_id);


--
-- Name: index_admin_assignments_on_schedule_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_assignments_on_schedule_id_and_user_id ON admin_assignments USING btree (schedule_id, user_id);


--
-- Name: index_allowed_shift_overlaps_on_shift_a_id_and_shift_b_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_allowed_shift_overlaps_on_shift_a_id_and_shift_b_id ON allowed_shift_overlaps USING btree (shift_a_id, shift_b_id);


--
-- Name: index_assignment_labels_on_text_and_shift_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assignment_labels_on_text_and_shift_id ON assignment_labels USING btree (text, shift_id);


--
-- Name: index_assignments_on_date_and_person_id_and_shift_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_assignments_on_date_and_person_id_and_shift_id ON assignments USING btree (date, person_id, shift_id);


--
-- Name: index_day_notes_on_schedule_id_and_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_day_notes_on_schedule_id_and_date ON day_notes USING btree (schedule_id, date);


--
-- Name: index_holidays_on_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_holidays_on_date ON holidays USING btree (date);


--
-- Name: index_nmff_statuses_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_nmff_statuses_on_person_id ON nmff_statuses USING btree (person_id);


--
-- Name: index_rotation_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rotation_assignments_on_person_id ON rotation_assignments USING btree (person_id);


--
-- Name: index_rotation_assignments_on_rotation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rotation_assignments_on_rotation_id ON rotation_assignments USING btree (rotation_id);


--
-- Name: index_rotation_schedules_on_start_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_rotation_schedules_on_start_date ON rotation_schedules USING btree (start_date);


--
-- Name: index_schedule_memberships_on_person_id_and_schedule_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schedule_memberships_on_person_id_and_schedule_id ON schedule_memberships USING btree (person_id, schedule_id);


--
-- Name: index_schedule_rotations_on_schedule_id_and_rotation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schedule_rotations_on_schedule_id_and_rotation_id ON schedule_rotations USING btree (schedule_id, rotation_id);


--
-- Name: index_schedules_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_schedules_on_title ON schedules USING btree (title);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_vacation_requests_on_requester_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vacation_requests_on_requester_id ON vacation_requests USING btree (requester_id);


--
-- Name: index_vacation_requests_on_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_vacation_requests_on_status ON vacation_requests USING btree (status);


--
-- Name: index_weekly_calendars_on_date_and_schedule_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_weekly_calendars_on_date_and_schedule_id ON weekly_calendars USING btree (date, schedule_id);


--
-- Name: index_weekly_shift_duration_rules_on_schedule_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_weekly_shift_duration_rules_on_schedule_id ON weekly_shift_duration_rules USING btree (schedule_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: contact_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT contact_fk FOREIGN KEY (contact_id) REFERENCES contacts(id);


--
-- Name: creator_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_totals_reports
    ADD CONSTRAINT creator_id_fk FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: editor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users(id);


--
-- Name: editor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deleted_assignments
    ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users(id);


--
-- Name: editor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_assignments
    ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users(id);


--
-- Name: editor_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_assignments
    ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users(id);


--
-- Name: guest_membership_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_assignments
    ADD CONSTRAINT guest_membership_fk FOREIGN KEY (guest_membership_id) REFERENCES guest_memberships(id);


--
-- Name: label_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT label_fk FOREIGN KEY (label_id) REFERENCES assignment_labels(id);


--
-- Name: label_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deleted_assignments
    ADD CONSTRAINT label_fk FOREIGN KEY (label_id) REFERENCES assignment_labels(id);


--
-- Name: outside_source_fund_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY outside_fund_assignments
    ADD CONSTRAINT outside_source_fund_id_fk FOREIGN KEY (outside_source_fund_id) REFERENCES funding_sources(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deleted_assignments
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_memberships
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY nmff_statuses
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacation_requests
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_assignments
    ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cme_meeting_requests
    ADD CONSTRAINT person_id_fk FOREIGN KEY (person_id) REFERENCES contacts(id);


--
-- Name: professional_fund_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY professional_fund_assignments
    ADD CONSTRAINT professional_fund_id_fk FOREIGN KEY (professional_fund_id) REFERENCES funding_sources(id);


--
-- Name: requester_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacation_requests
    ADD CONSTRAINT requester_fk FOREIGN KEY (requester_id) REFERENCES users(id);


--
-- Name: requester_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cme_meeting_requests
    ADD CONSTRAINT requester_id_fk FOREIGN KEY (requester_id) REFERENCES users(id);


--
-- Name: rotation_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_assignments
    ADD CONSTRAINT rotation_fk FOREIGN KEY (rotation_id) REFERENCES rotations(id);


--
-- Name: rotation_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_rotations
    ADD CONSTRAINT rotation_fk FOREIGN KEY (rotation_id) REFERENCES rotations(id);


--
-- Name: rotation_schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rotation_assignments
    ADD CONSTRAINT rotation_schedule_fk FOREIGN KEY (rotation_schedule_id) REFERENCES rotation_schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY weekly_calendars
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_shifts
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_memberships
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY weekly_shift_duration_rules
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_assignments
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY calendar_audits
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_memberships
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY day_notes
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacation_requests
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_rotations
    ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_totals_reports
    ADD CONSTRAINT schedule_id_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY shift_groups
    ADD CONSTRAINT schedule_id_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: schedule_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cme_meeting_requests
    ADD CONSTRAINT schedule_id_fk FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: shift_a_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allowed_shift_overlaps
    ADD CONSTRAINT shift_a_fk FOREIGN KEY (shift_a_id) REFERENCES shifts(id);


--
-- Name: shift_b_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY allowed_shift_overlaps
    ADD CONSTRAINT shift_b_fk FOREIGN KEY (shift_b_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule_shifts
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignment_labels
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deleted_assignments
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY guest_assignments
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vacation_requests
    ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: shift_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cme_meeting_requests
    ADD CONSTRAINT shift_id_fk FOREIGN KEY (shift_id) REFERENCES shifts(id);


--
-- Name: user_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_assignments
    ADD CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('24');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');
