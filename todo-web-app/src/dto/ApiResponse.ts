export interface ApiResponse {
    code?: number;
    error?: string;
}

export interface LoginResponse extends ApiResponse {
    username: string;
    full_name: string;
    user_uid: string;
    token: string;
}

export interface SignUpResponse extends ApiResponse {
    username: string;
    full_name: string;
    user_uid: string;
}

export interface ListAllTasksResponse extends ApiResponse {
    tasks: TaskItem[];
    meta: {
        current_page: number;
        total_pages: number;
        total_count: number;
    }
}

export interface TaskItem {
    id: number;
    created_at: string;
    task_content: string;
    task_remind_at: string;
    task_title: string;
    task_uid: string;
    updated_at: string;
    created_by: string;
    updated_by: string;
}