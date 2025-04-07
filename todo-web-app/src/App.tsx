import { App as AntDesignApp } from "antd";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Demo from "./components/demo/Demo";
import NotFound from "./utils/NotFound";

function App() {
  return (
      <AntDesignApp>
          <BrowserRouter>
              <Routes>
                  <Route path="/" element={<Demo />}></Route>
                  <Route path="*" element={<NotFound />} />
              </Routes>
          </BrowserRouter>
      </AntDesignApp>
  );
}

export default App;
