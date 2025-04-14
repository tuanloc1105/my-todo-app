import React from "react";
import {useAppContext} from "../../context/AppProvider.tsx";
import {useNavigateTo} from "../../utils/navigation.ts";
import {Button, ConfigProvider, Input, notification, theme} from "antd";
import {LoginOutlined} from "@ant-design/icons";

const Login: React.FC = () => {
    const navigateTo = useNavigateTo();
    const [api, contextHolder] = notification.useNotification();
    type NotificationType = 'success' | 'info' | 'warning' | 'error';
    const {lightTheme} = useAppContext();

    const openNotificationWithIcon = (type: NotificationType, contentL: string) => {
        api[type]({
            message: (
                <p className="font-bold font-sans">Notification</p>
            ),
            description: (
                <p className="font-sans">{contentL}</p>
            ),
        });
    };

    return (
        <>
            {contextHolder}
            <div
                className={
                    (
                        lightTheme ? "bg-gradient-to-r from-purple-900 to-yellow-50" :
                            "bg-gradient-to-r from-purple-900 to-stone-900"
                    ) + " w-screen h-screen flex flex-col items-center justify-center gap-5 font-sans"
                }
            >
                <ConfigProvider
                    theme={{
                        token: {
                            fontFamily: "Montserrat"
                        },
                        algorithm: lightTheme ? theme.defaultAlgorithm : theme.darkAlgorithm
                    }}
                >
                    <h1 className="bg-gradient-to-r from-violet-600 to-indigo-600 bg-clip-text text-transparent text-3xl font-bold">
                        TODO LIST
                    </h1>
                    <div
                        className="flex flex-col gap-2 w-1/2 items-center"
                    >
                        <Input
                            style={{width: '50%'}}
                            placeholder="Enter username..."
                            // value={username}
                            // onChange={(value) => {
                            //     setUsername(value.target.value)
                            // }}
                        />
                        <Input.Password
                            style={{width: '50%'}}
                            placeholder="Enter password..."
                            // value={password}
                            // onChange={(value) => {
                            //     setPassword(value.target.value)
                            // }}
                            // onKeyDown={handlePressEnter}
                        />
                        <ConfigProvider
                            theme={{
                                token: {
                                    colorPrimary: "#8b5cf6",
                                    colorTextLightSolid: "black",
                                }
                            }}
                        >
                            <Button
                                type="primary"
                                icon={<LoginOutlined/>}
                                iconPosition="end"
                            >
                                Login
                            </Button>
                        </ConfigProvider>
                    </div>
                </ConfigProvider>

            </div>
        </>
    );
}

export default Login;
