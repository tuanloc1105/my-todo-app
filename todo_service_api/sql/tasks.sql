CREATE TABLE public.tasks
(
    created_at        TIMESTAMP    DEFAULT current_timestamp    NOT NULL,
    id                SERIAL       PRIMARY KEY,
    task_content      VARCHAR      NOT NULL,
    task_remind_at    TIMESTAMP    DEFAULT current_timestamp    NOT NULL,
    task_title        VARCHAR      NOT NULL,
    task_uid          VARCHAR      NOT NULL,
    updated_at        TIMESTAMP    DEFAULT current_timestamp    NOT NULL
);

ALTER TABLE public.tasks
    ADD CONSTRAINT task_uid_unique UNIQUE (task_uid);
