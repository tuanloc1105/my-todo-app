export interface ApiResponse {
    trace: string;
    errorCode: number;
    errorDescription?: string;
    httpCode: number;
}
