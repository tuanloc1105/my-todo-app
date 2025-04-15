import React from "react";

const Loading: React.FC = () => {
    return (
        <div className="fixed inset-0 flex items-center justify-center bg-black opacity-30 z-50">
            <div className="w-16 h-16 border-4 border-white border-t-transparent rounded-full animate-spin"></div>
        </div>
    );
};

export default Loading;
