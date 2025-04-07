import React, {useState} from 'react'
import {PlusOutlined} from "@ant-design/icons";
import {Button, ConfigProvider} from "antd";

const Demo: React.FC = () => {
    const [count, setCount] = useState(0)

    return (
        <>
            <div className="bg-gray-800 w-screen h-screen flex flex-col items-center justify-center gap-5 font-sans">
                <h1 className="text-white text-3xl">Vite + React + TailwindCSS + Ant Design</h1>
                <div className="flex gap-10">
                    <a href="https://react.dev/" target="_blank">
                        <img className="w-32 animate-spin" style={{animationDuration: '5s'}}
                             src="/src/assets/react.svg"/>
                    </a>
                    <PlusOutlined style={{color: 'white'}}/>
                    <a href="https://vite.dev" target="_blank">
                        <img className="w-32" src="/public/vite.svg"/>
                    </a>
                </div>
                <div className="flex flex-col gap-10 items-center justify-center">
                    <ConfigProvider
                        theme={{
                            token: {
                                fontFamily: "Montserrat",
                                // algorithm: theme.darkAlgorithm
                            }
                        }}
                    >
                        <Button
                            type="primary"
                            shape="round"
                            icon={<PlusOutlined/>}
                            onClick={() => {
                                setCount((count) => count + 1);
                            }}
                        >
                            count is {count}
                        </Button>
                    </ConfigProvider>
                    <p className="text-white">
                        Edit <code>src/App.tsx</code> and save to test HMR
                    </p>
                </div>
                <p className="text-white">
                    Click on the Vite and React logos to learn more
                </p>
            </div>
        </>
    )
}

export default Demo;
