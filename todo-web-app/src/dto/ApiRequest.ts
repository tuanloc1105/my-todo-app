export interface LoginRequest {
    username: string;
    password: string;
}

export interface SignUpRequest {
    username: string;
    password: string;
    full_name: string;
}

export interface ListAllTasksRequest {
    page_no: number;
}