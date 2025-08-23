#!/usr/bin/env python3
"""
FastAPI backend for real-time PNTP swarm simulation with WebSocket telemetry
"""
import asyncio
import json
import os
import random
import time
from typing import Dict, List, Optional, Set

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.staticfiles import StaticFiles

from ..src.synchronization import (
    PNTPEnsemble,
    PNTPNode,
    PNTPTelemetry,
    SyncMode,
    RadioDomain,
)


class SimulationConfig:
    """Configuration of the simulation."""
    def __init__(self,
                num_nodes: int = 30,
                master_clock_type: str = "RB",
                dt_seconds: float = 0.1,
                telemetry_interval_seconds: float = 0.5):
        self.num_nodes = max(2, int(num_nodes))
        self.master_clock_type = master_clock_type
        self.dt_seconds = max(0.01, float(dt_seconds))
        self.telemetry_interval_seconds = max(0.1, float(telemetry_interval_seconds))


class SimulationManager:
    """Runs PNTP ensemble simulation and broadcasts telemetry to WebSocket clients."""
    def __init__(self):
        self.ensemble: Optional[PNTPEnsemble] = None
        self.telemetry: Optional[PNTPTelemetry] = None
        self.sim_task: Optional[asyncio.Task] = None
        self.config: Optional[SimulationConfig] = None
        self.clients: Set[WebSocket] = set()
        self._running: bool = False

    async def start(self, config: SimulationConfig):
        if self._running:
            await self.stop()
        self.config = config
        self.ensemble = PNTPEnsemble("web_drone_swarm")
        self.telemetry = PNTPTelemetry()
        self._create_nodes(config)
        self._running = True
        self.sim_task = asyncio.create_task(self._run_loop())

    def _create_nodes(self, config: SimulationConfig):
        """Create PNTP nodes with one master (RB/selected) and the rest as slaves/relays."""
        if not self.ensemble:
            return
        # Master node
        master = PNTPNode(
            node_id="master",
            sync_mode=SyncMode.MASTER,
            radio_domains=[RadioDomain.WIFI_6, RadioDomain.LORA_SUBGHZ]
        )
        master.clock_discipline = master.clock_discipline.__class__("master", config.master_clock_type)
        master.packet_loss_rate = 0.01
        master.signal_strength = -30.0
        self.ensemble.add_node(master)
        # Other nodes
        for i in range(1, config.num_nodes):
            node = PNTPNode(
                node_id=f"node_{i:02d}",
                sync_mode=random.choice([SyncMode.SLAVE, SyncMode.RELAY]),
                radio_domains=random.sample(list(RadioDomain), k=random.randint(1, 2))
            )
            node.clock_discipline = node.clock_discipline.__class__(f"node_{i:02d}", random.choice(["OCXO", "TCXO", "QUARTZ"]))
            node.packet_loss_rate = random.uniform(0.05, 0.2)
            node.signal_strength = random.uniform(-65, -40)
            node.multipath_delay = random.uniform(0, 0.0005)
            node.multipath_variance = random.uniform(0, 0.0001)
            self.ensemble.add_node(node)

    async def stop(self):
        self._running = False
        if self.sim_task:
            self.sim_task.cancel()
            try:
                await self.sim_task
            except asyncio.CancelledError:
                pass
        finally:
            self.sim_task = None
            self.ensemble = None
            self.telemetry = None

    async def _run_loop(self):
        """Main simulation loop: run PNTP cycles and broadcast telemetry."""
        assert self.ensemble is not None and self.telemetry is not None and self.config is not None
        last_telemetry_time = time.time()
        while self._running:
            # Advance PNTP simulation by one step
            self.ensemble.run_sync_cycle(self.config.dt_seconds)
            for node in self.ensemble.nodes.values():
                node.update_sync_metrics()
            # Periodically collect telemetry and broadcast
            now = time.time()
            if now - last_telemetry_time >= self.config.telemetry_interval_seconds:
                self.telemetry.collect_telemetry(self.ensemble)
                payload = self._build_telemetry_payload()
                await self._broadcast(payload)
                last_telemetry_time = now
            await asyncio.sleep(self.config.dt_seconds)

    def _build_telemetry_payload(self) -> Dict:
        assert self.ensemble is not None
        metrics = self.ensemble.ensemble_metrics.copy()
        # Downsample node telemetry for payload size
        nodes_sample: Dict[str, Dict[str, float]] = {}
        for node_id, node in list(self.ensemble.nodes.items())[:20]:
            nodes_sample[node_id] = {
                "offset_us": float(node.clock_discipline.clock_state.offset),
                "freq_offset_ppm": float(node.clock_discipline.clock_state.frequency_offset),
                "stratum": int(node.stratum),
                "sync_quality": float(node.sync_metrics.get("sync_quality", 0.0)),
            }
        return {
            "type": "telemetry",
            "ensemble": metrics,
            "nodes": nodes_sample,
        }

    async def _broadcast(self, message: Dict):
        if not self.clients:
            return
        text = json.dumps(message)
        dead: List[WebSocket] = []
        for ws in list(self.clients):
            try:
                await ws.send_text(text)
            except Exception:
                dead.append(ws)
        for ws in dead:
            try:
                await ws.close()
            except Exception:
                pass
            self.clients.discard(ws)


app = FastAPI(title="PNTP Swarm Simulator")

# Static files (index.html)
static_dir = os.path.join(os.path.dirname(__file__), "static")
if not os.path.isdir(static_dir):
    os.makedirs(static_dir, exist_ok=True)
app.mount("/static", StaticFiles(directory=static_dir), name="static")

sim_manager = SimulationManager()


@app.get("/", response_class=HTMLResponse)
async def index():
    index_path = os.path.join(static_dir, "index.html")
    if not os.path.isfile(index_path):
        return HTMLResponse("<h1>PNTP Swarm Simulator</h1><p>index.html not found.</p>")
    with open(index_path, "r", encoding="utf-8") as f:
        return HTMLResponse(f.read())


@app.post("/start")
async def start_sim(request: Request):
    data = await request.json()
    config = SimulationConfig(
        num_nodes=data.get("num_nodes", 30),
        master_clock_type=data.get("master_clock_type", "RB"),
        dt_seconds=data.get("dt_seconds", 0.1),
        telemetry_interval_seconds=data.get("telemetry_interval_seconds", 0.5),
    )
    await sim_manager.start(config)
    return JSONResponse({"status": "started", "config": {
        "num_nodes": config.num_nodes,
        "master_clock_type": config.master_clock_type,
        "dt_seconds": config.dt_seconds,
        "telemetry_interval_seconds": config.telemetry_interval_seconds,
    }})


@app.post("/stop")
async def stop_sim():
    await sim_manager.stop()
    return JSONResponse({"status": "stopped"})


@app.get("/status")
async def status():
    return JSONResponse({
        "running": sim_manager._running,
        "clients": len(sim_manager.clients),
        "config": None if not sim_manager.config else {
            "num_nodes": sim_manager.config.num_nodes,
            "master_clock_type": sim_manager.config.master_clock_type,
            "dt_seconds": sim_manager.config.dt_seconds,
            "telemetry_interval_seconds": sim_manager.config.telemetry_interval_seconds,
        }
    })


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    sim_manager.clients.add(websocket)
    try:
        while True:
            # Keep the socket alive and accept control messages from client if any
            _ = await websocket.receive_text()
    except WebSocketDisconnect:
        pass
    finally:
        sim_manager.clients.discard(websocket)


if __name__ == "__main__":
    import uvicorn
    print("🚀 Запуск PNTP Swarm Simulator на http://localhost:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)