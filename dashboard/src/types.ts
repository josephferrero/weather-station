export interface SensorReading {
  id: number;
  timestamp: string;
  temperature: number;
  humidity: number;
  pressure: number;
  altitude: number;
  gasResistance: number;
}
