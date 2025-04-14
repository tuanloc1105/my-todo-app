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
    token: string;
}
