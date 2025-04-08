CREATE TABLE public.users
(
    active        BOOLEAN      DEFAULT false                NOT NULL,
    created_at    TIMESTAMP    DEFAULT current_timestamp    NOT NULL,
    full_name     VARCHAR      DEFAULT ''                   NOT NULL,
    id            SERIAL       PRIMARY KEY,
    password      VARCHAR      NOT NULL,
    updated_at    TIMESTAMP    DEFAULT current_timestamp    NOT NULL,
    user_uid      VARCHAR      NOT NULL,
    username      VARCHAR      NOT NULL
);


ALTER TABLE public.users
    ADD CONSTRAINT user_uid_unique UNIQUE (user_uid);

ALTER TABLE public.users
    ADD CONSTRAINT username_unique UNIQUE (username);
