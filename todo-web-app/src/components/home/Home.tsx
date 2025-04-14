import React from "react";
import {useAppContext} from "../../context/AppProvider.tsx";
import {ConfigProvider} from "antd";

const Home: React.FC = () => {

    const {lightTheme} = useAppContext();

    return (
        <>
            <div
                className={
                    (
                        lightTheme ? "bg-gradient-to-r from-purple-900 to-yellow-50" :
                            "bg-gradient-to-r from-purple-900 to-stone-900"
                    ) + "w-screen h-screen flex flex-col items-center justify-center gap-5 font-sans"
                }
            >
                <ConfigProvider
                    theme={{
                        token: {
                            fontFamily: "Montserrat"
                        }
                    }}
                >
                    <h1 className="bg-gradient-to-r from-stone-50 to-purple-900 text-3xl font-bold bg-clip-text text-transparent">
                        TODO LIST
                    </h1>
                </ConfigProvider>
            </div>
        </>
    );
}

export default Home;
